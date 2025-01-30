output "vpc_id" {
  description = "the ID of the VPC"
  value       = module.aws_vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.aws_vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.aws_vpc.public_subnets_cidr_blocks
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.aws_vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.aws_vpc.private_subnets_cidr_blocks
}

output "nat_gw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.aws_vpc.nat_gw_ids
}

output "nat_gw_public_ips" {
  description = ""
  value       = module.aws_vpc.nat_gw_public_ips
}

output "cloudtrail_bucket_arn" {
  value = module.aws_cloudtrails.cloudtrail_bucket_arn
}

output "cloudtrail_bucket_name" {
  value = module.aws_cloudtrails.cloudtrail_bucket_name
}

# output "dns_zone_id" {
#   description = "DNS Zone IDs"
#   value       = module.aws_route53_public.public_dns_zone_id
# }

# output "aws_dns_name_servers" {
#   description = "AWS DNS Name Servers"
#   value       = module.aws_route53_public.public_zone_aws_dns_name_servers
# }