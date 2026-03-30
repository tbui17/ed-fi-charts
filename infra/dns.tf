resource "cloudflare_record" "dashboard" {
  zone_id = var.cloudflare_zone_id
  name    = var.site_address
  content = hcloud_server.default.ipv4_address
  type    = "A"
  ttl     = 300
  proxied = false
}
