locals {
  admin_username = "azureuser"
  content  = templatefile("${path.root}/customdata.tpl", {
    attack_script_name = "attack_simulation.sh"
    admin_username = local.admin_username
  })
}
