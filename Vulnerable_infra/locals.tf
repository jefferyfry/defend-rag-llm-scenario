locals {
  prefix          = var.prefix
  suffix          = random_string.unique_id.id
  environment     = var.environment
  s3_bucket_name  = "${var.prefix}-bucket-${var.environment}-${random_string.unique_id.id}"
  cloudtrail_name = "${var.prefix}-cloudtrail-${var.environment}-${random_string.unique_id.id}"
}