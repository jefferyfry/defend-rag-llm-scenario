data "azurerm_subnet" "subnet" {
  name = "defend-attack-demo-subnet"
  resource_group_name = "defend-attack-demo"
  virtual_network_name = "defend-attack-demo-vn"
}
