module "attack-vm" {
  source = "./modules/attacker-vm"

  zone = "1"
  location = "Mexico Central"
  name = "defend-rag-llm-attack-vm"
  resource_group_name = "defend-rag-llm-attack-scenario"
  admin_username = local.admin_username
  custom_data = base64encode(local.content)
  private_subnet_id = data.azurerm_subnet.subnet.id
}
