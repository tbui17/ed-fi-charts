resource "hcloud_ssh_key" "default" {
  name       = "${var.server_name}-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_firewall" "default" {
  name = "${var.server_name}-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "default" {
  name         = var.server_name
  server_type  = var.server_type
  location     = var.location
  image        = "ubuntu-24.04"
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.default.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(replace(var.ssh_public_key_path, ".pub", ""))
    host        = self.ipv4_address
  }

  # Create remote directories
  provisioner "remote-exec" {
    inline = ["mkdir -p /opt/edfi/sql"]
  }

  # Upload compose file
  provisioner "file" {
    source      = "${path.module}/../docker-compose.prod.yml"
    destination = "/opt/edfi/docker-compose.yml"
  }

  # Upload Caddyfile
  provisioner "file" {
    source      = "${path.module}/../Caddyfile"
    destination = "/opt/edfi/Caddyfile"
  }

  # Tar SQL locally, upload, extract on server
  provisioner "local-exec" {
    command = "tar -cf ${path.module}/sql.tar -C ${path.module}/../sql ."
  }

  provisioner "file" {
    source      = "${path.module}/sql.tar"
    destination = "/opt/edfi/sql.tar"
  }

  provisioner "remote-exec" {
    inline = [
      "tar -xf /opt/edfi/sql.tar -C /opt/edfi/sql",
      "rm /opt/edfi/sql.tar"
    ]
  }

  # Write .env file
  provisioner "remote-exec" {
    inline = [
      <<-EOT
      cat > /opt/edfi/.env <<'ENVEOF'
TAG=${var.tag}
POSTGRES_USER=${var.postgres_user}
POSTGRES_PASSWORD=${local.postgres_password}
SITE_ADDRESS=${var.site_address}
TPDM_ENABLED=true
ENVEOF
      EOT
      ,
      "chmod 600 /opt/edfi/.env"
    ]
  }

  # Upload and run setup script
  provisioner "file" {
    source      = "${path.module}/scripts/setup.sh"
    destination = "/opt/edfi/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /opt/edfi/setup.sh",
      "/opt/edfi/setup.sh '${var.ghcr_user}' '${var.ghcr_token}'"
    ]
  }
}
