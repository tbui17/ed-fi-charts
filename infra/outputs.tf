output "server_ip" {
  description = "Public IPv4 address of the server"
  value       = hcloud_server.default.ipv4_address
}

output "dashboard_url" {
  description = "URL to access the Ed-Fi dashboard"
  value       = "https://${var.site_address}"
}

output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh root@${hcloud_server.default.ipv4_address}"
}
