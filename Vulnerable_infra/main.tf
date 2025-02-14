resource "random_string" "unique_id" {
  length  = 4
  lower   = true
  upper   = false
  special = false
}

module "sensitive_bucket" {
  source = "./modules/terraform-aws-s3-data"

  environment             = "prod"
  prefix                  = var.prefix
  suffix                  = local.suffix
  ragserver_role_arn      = aws_iam_role.ragserver_role.arn
}

module "aws_defend_base_infra_prod" {
  source                  = "./modules/terraform-aws-base-infra"
  vpc_name                = "wiz-rag-defend-prod"
  vpc_azs                 = var.vpc_azs
  vpc_internet_gateway    = "true"
  vpc_single_nat_gateway  = "true"
  vpc_nat_gateway_per_az  = "false"
  vpc_cidr                = "10.0.0.0/16"
  vpc_public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_private_subnet_cidr = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  //cloudtrail_name         = local.cloudtrail_name
  //s3_bucket_name          = local.s3_bucket_name

  x_tags = {
    "Name"        = "WIZ-RAG-DEFEND-PROD"
    "owner"       = "HOL Admins"
    "purpose"     = "HOL"
    "environment" = local.environment
    "Managed By"  = "Terraform"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "defend-rag-llm-key"
  public_key = file("~/.ssh/test_key.pub")
}

module "aws_vectordb_instance" {
  source                  = "./modules/terraform-aws-vectordb-instance"
  owner                   = "HOL Admins"
  prefix                  = local.prefix
  suffix                  = local.suffix
  environment             = local.environment
  ttl                     = "1h"
  iam_instance_profile    = aws_iam_instance_profile.vectordbserver_instance_profile.name
  vpc_private_subnets     = module.aws_defend_base_infra_prod.private_subnets
  vpc_public_subnets      = module.aws_defend_base_infra_prod.public_subnets
  vpc_id                  = module.aws_defend_base_infra_prod.vpc_id
  key_name = aws_key_pair.key_pair.key_name
  client_id               = var.client_id
  client_secret           = var.client_secret

  tags = {
    "Name"        = "WIZ-vectordb-DEFEND-PROD"
    "owner"       = "HOL Admins"
    "purpose"     = "HOL"
    "environment" = "production"
    "Managed By"  = "Terraform"
  }
}

module "aws_rag_instance" {
  source                  = "./modules/terraform-aws-rag-instance"
  owner                   = "HOL Admins"
  prefix                  = local.prefix
  suffix                  = local.suffix
  environment             = local.environment
  ttl                     = "1h"
  iam_instance_profile    = aws_iam_instance_profile.ragserver_instance_profile.name
  instance_type           = "t2.large"
  vpc_private_subnets     = module.aws_defend_base_infra_prod.private_subnets
  vpc_public_subnets      = module.aws_defend_base_infra_prod.public_subnets
  vpc_id                  = module.aws_defend_base_infra_prod.vpc_id
  key_name = aws_key_pair.key_pair.key_name
  client_id               = var.client_id
  client_secret           = var.client_secret
  vectordb_ip             = module.aws_vectordb_instance.instance_private_ip[0]
  bucket_name             = module.sensitive_bucket.bucket_name
  region                  = var.region
  role_name               = aws_iam_role.ragserver_role.name
  tags = {
    "Name"        = "WIZ-RAG-DEFEND-PROD"
    "owner"       = "HOL Admins"
    "purpose"     = "HOL"
    "environment" = "production"
    "Managed By"  = "Terraform"
  }
}