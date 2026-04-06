output "subnet_id" {
  description = "The ID of the subnet created within the virtual network."
  value       = azurerm_subnet.subnet.id
}