output "cloudtrail_id" {
  value       = join("", aws_cloudtrail.defend[*].id)
  description = "The ID of the trail. (Name for provider < v5, ARN for provider >= v5)."
}

output "cloudtrail_home_region" {
  value       = join("", aws_cloudtrail.defend[*].home_region)
  description = "The region in which the trail was created"
}

output "cloudtrail_arn" {
  value       = join("", aws_cloudtrail.defend[*].arn)
  description = "The Amazon Resource Name of the trail"
}

output "cloudtrail_bucket_arn" {
  value       = join("", aws_s3_bucket.defend[*].arn)
  description = "The Amazon Resource Name of the bucket used for trail"
}

output "cloudtrail_bucket_name" {
  value       = join("", aws_s3_bucket.defend[*].id)
  description = "The Name of the bucket used for trail"
}