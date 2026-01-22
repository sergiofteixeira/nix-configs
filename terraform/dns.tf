data "cloudflare_zone" "main" {
  filter = {
    name = var.domain
  }
}

# Root domain A record
resource "cloudflare_dns_record" "root" {
  zone_id = data.cloudflare_zone.main.id
  name    = var.domain
  content = var.server_ip
  type    = "A"
  ttl     = 3600
  proxied = false
}

# Service subdomains
locals {
  subdomains = [
    "bazarr",
    "jellyfin",
    "prowlar",
    "radar",
    "sonar",
    "jellyseer",
    "qbittorrent",
    "grafana",
    "prometheus",
  ]
}

resource "cloudflare_dns_record" "subdomains" {
  for_each = toset(local.subdomains)
  
  zone_id = data.cloudflare_zone.main.id
  name    = each.value
  content = var.server_ip
  type    = "A"
  ttl     = 3600
  proxied = false
}
