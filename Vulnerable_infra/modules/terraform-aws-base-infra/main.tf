module "aws_vpc" {
  source                        = "./terraform-aws-vpc"
  name                          = var.vpc_name
  azs                           = var.vpc_azs
  internet_gateway              = var.vpc_internet_gateway
  single_nat_gateway            = var.vpc_single_nat_gateway
  one_nat_gateway_per_az        = var.vpc_nat_gateway_per_az
  vpc_cidr_block                = var.vpc_cidr
  vpc_public_subnet_cidr_block  = var.vpc_public_subnet_cidr
  vpc_private_subnet_cidr_block = var.vpc_private_subnet_cidr
  tags = var.x_tags
}

module "aws_cloudtrails" {
  source                        = "./terraform-aws-cloudtrails"
  cloudtrail_name               = var.cloudtrail_name
  enable_logging                = var.enable_logging
  multi_region                  = var.multi_region
  global_service                = var.global_service
  add_s3_bucket                 = var.add_s3_bucket
  s3_bucket_name                = var.s3_bucket_name
  s3_bucket_force_destroy       = var.s3_bucket_force_destroy
  tags = var.x_tags
}


