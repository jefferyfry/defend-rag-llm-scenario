output "attacker-machine-public-ip" {
  value = module.attack-vm.attacker-machine-public-ip.network_interface_1-ip_configuration_1.ip_address
}