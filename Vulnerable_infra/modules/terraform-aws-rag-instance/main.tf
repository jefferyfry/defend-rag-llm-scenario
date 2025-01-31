locals {
  key_name = "${var.prefix}-raginst-keypair-${var.environment}-${var.suffix}"
  sg_name = "${var.prefix}-sg-${var.environment}-${var.suffix}"
  tags = {
      "Customer" = var.prefix
      "Owner" = var.owner
      "Purpose" = "HOL"
      "Environnement" = var.environment
      "TTL" = var.ttl
      "Created-Date" = timestamp()
      "Managed By" = "Terraform"
    }
}

module "aws_key_pair" {
  source     = "./terraform-aws-keypair"
  key_name   = local.key_name
  public_key = var.aws_key_pair_public_key
}

module "aws_sg_ragserver" {
  source      = "./terraform-aws-securitygroup"
  name        = "ragserver"
  description = "Security Group for ${local.sg_name}"
  vpc_id      = var.vpc_id

  custom_security_rules = [
    {
      "type"        = "egress"
      "from_port"   = "0"
      "to_port"     = "65535"
      "protocol"    = "-1"
      "description" = "Allow all"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "type"        = "ingress"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "description" = "SSH Access to ragserver"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "type"        = "ingress"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "description" = "instance Connect Access via Console to ragserver"
      "cidr_blocks" = join(",",data.aws_ec2_managed_prefix_list.instance_connect.entries[*].cidr)
    },
    {
      "type"        = "ingress"
      "from_port"   = "5000"
      "to_port"     = "5000"
      "protocol"    = "tcp"
      "description" = "Web Access to Web Server"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "type"        = "ingress"
      "from_port"   = "4444"
      "to_port"     = "4444"
      "protocol"    = "tcp"
      "description" = "Web Access to Web Server"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "type"        = "ingress"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "description" = "Web Access to Web Server"
      "cidr_blocks" = "0.0.0.0/0"
    },

  ]
    tags =    local.tags
}

module "aws_instance_ragserver" {
  source = "./terraform-aws-instance"
  ami    = data.aws_ami.ami.id

  instance_tags = {"Name" = "${var.prefix}-ragserver-${var.environment}-${var.suffix}"}
  tags =    local.tags

  vm_count                    = "1"
  vpc_security_group_ids      = [module.aws_sg_ragserver.sg_id]
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.vpc_public_subnets[0]
  key_name                    = module.aws_key_pair.key_name
  associate_public_ip_address = true
  client_id   = var.client_id
  client_secret = var.client_secret
  vectordb_ip = var.vectordb_ip
  bucket_name = var.bucket_name

}


