output "server_ip" {
  description = "Public IPv4 address of the server"
  value       = hcloud_server.coolify.ipv4_address
}

output "coolify_url" {
  description = "URL to access the Coolify UI"
  value       = "http://${hcloud_server.coolify.ipv4_address}:8000"
}

output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh root@${hcloud_server.coolify.ipv4_address}"
}
