locals {
  admin_username = "azureuser"
  content  = templatefile("${path.root}/customdata.tpl", {
    target_host = var.target_host
    admin_username = local.admin_username
    aws_key_pair_private_key = file("~/.ssh/test_key.pub")
  })
}
