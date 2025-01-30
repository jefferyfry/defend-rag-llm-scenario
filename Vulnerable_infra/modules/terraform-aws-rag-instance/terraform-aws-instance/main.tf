resource "aws_instance" "vm" {
  count = var.vm_count

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  user_data                   = data.cloudinit_config.server_config.rendered
  iam_instance_profile        = var.iam_instance_profile

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content { 
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = lookup(ebs_block_device.value, "device_name", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
    }
  }


  tags = merge(var.tags, var.instance_tags)

  volume_tags = var.tags
  
  lifecycle {
    ignore_changes = [tags["Created-Date"],ami,volume_tags["Created-Date"],user_data]
  }
}

data "cloudinit_config" "server_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("./rag-inst-files/server.yml", {
      content-app = filebase64("./rag-inst-files/app.py")
      content-req = filebase64("./rag-inst-files/requirements.txt")
      client_id = var.client_id
      client_secret = var.client_secret
    })
  }
}
