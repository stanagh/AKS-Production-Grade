output "dns_zone_id" {
  description = "The ID of the DNS zone created."
  value       = data.azurerm_dns_zone.dns_zone.id
}