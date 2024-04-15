output "public_ip_address" {
  value       = azurerm_public_ip.example.ip_address
  description = "The public IP attached to the VM to connect"
}