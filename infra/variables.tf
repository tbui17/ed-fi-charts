variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cpx21"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "ash"
}

variable "server_name" {
  description = "Name for the server"
  type        = string
  default     = "edfi"
}

variable "ghcr_user" {
  description = "GitHub Container Registry username"
  type        = string
}

variable "ghcr_token" {
  description = "GitHub Container Registry PAT (read:packages)"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string

}

variable "site_address" {
  description = "Full domain/subdomain for the dashboard (e.g., dashboard.example.com)"
  type        = string
  default = ""
}

variable "postgres_user" {
  description = "PostgreSQL superuser username"
  type        = string

}

variable "postgres_password" {
  description = "PostgreSQL superuser password (auto-generated if not set)"
  type        = string

  default     = ""
}

variable "tag" {
  description = "Ed-Fi ODS Docker image tag"
  type        = string
  default     = "7.3.0"
}
