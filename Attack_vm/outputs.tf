output "attacker-machine-public-ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}