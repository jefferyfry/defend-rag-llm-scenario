

module "attacker-instance" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"

  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  zone                = var.zone

  custom_data = var.custom_data

  encryption_at_host_enabled = false

  os_type = "Linux"

  network_interfaces = {
    network_interface_1 = {
      name = "${var.name}-nic"
      network_security_groups = {
        network_security_group_resource_id = {
          network_security_group_resource_id = azurerm_network_security_group.vm.id
        }
        }
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${var.name}-nic-ipconfig1"
          private_ip_subnet_resource_id = var.private_subnet_id
          create_public_ip_address      = true
          public_ip_address_name        = "${var.name}-nic-publicip1"
        }
      }
    }
  }


  source_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
}

  admin_username = var.admin_username

  admin_ssh_keys = [{
      username        = "azureuser"
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrbF16OyPZt6sL33/qUPhBB85tU7kdEhU+pc9c4FojYJ8XsBRI3AOs9SdFWzkUJkFhRnG3UoMskS7n6bXxdIZb/t4MV5Yhg8R3HvPX4OZZRjku8puC9U1uxXDqqChJbGAHQUj9ER7CHQlDNLt8/P/AIG/SSlkxE7O43nte3qkzQ03AQcHDH0aSZSoE4xr9TxaaRVcEwr/digmnSYhFJPTIrVGOYxB6jCI/M0cbuescOMqib7avVd9HKgPqhJ7e8dyNqWW3RZkDrbaG4wCl4sNeHwEAkcMaXhAwfVytvIwCROD++UIRBl828VKhLdelWPAIEx7HKyl0p8PfJX+kn3EMPMGGcrXTGhi/YZCfYi0Ba284vpx1DH6+5ilwmn/TXpdA8yUT+TdsKlYzhEmah3VDQ7pnR35CEhbxrBmW27X1RXyQcpeHPt6P5c4iWtqMRX7+Hg2m/qXlTYfEf+BNKtSQOzP/2DVkdsEivz287SqUgZsDExHccbU4HJZCx0Xwmo8= nicolas@nicolas-R6X0J2QDF6"
    }]
}

resource "azurerm_network_security_group" "vm" {
  location            = var.location
  name                = "${var.name}-sg"
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow_remote_access_to_vm"
    description                = "Allow remote protocol in from all locations"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-reverse-shell"
    description                = "Allow remote protocol in from all locations"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4444"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
