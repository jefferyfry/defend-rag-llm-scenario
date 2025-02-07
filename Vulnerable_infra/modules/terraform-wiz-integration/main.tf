module "wiz" {
  source             = "https://s3-us-east-2.amazonaws.com/wizio-public/deployment-v2/aws/wiz-aws-native-terraform-terraform-module.zip"
  external-id        = "ff1e8d03-77ee-4a4e-87b4-2d2aece52552"
  data-scanning      = true
  rolename           = "WizAccess-Role-Defend"
  iam_policy_suffix  = "Defend"
  lightsail-scanning = true
  remote-arn         = "arn:aws:iam::197171649850:role/prod-us22-AssumeRoleDelegator"
}

# module "aws_cloud_events" {
#   depends_on = [module.wiz, wiz_aws_connector.defend_connector]
#   source = "https://downloads.wiz.io/customer-files/aws/wiz-aws-cloud-events-terraform-module.zip"
#
#   integration_type = "S3"
#
#   cloudtrail_bucket_arn = var.cloudtrail_bucket_arn
#
#   use_existing_sns_topic = false
#   #  sns_topic_arn                = "<EXISTING_SNS_TOPIC_ARN>"
#   sns_topic_encryption_enabled = false
#
#   wiz_access_role_arn = module.wiz.role_arn
# }


resource "wiz_aws_connector" "defend_connector" {
  name = "Wiz-Defend-Lab004"
  auth_params {
    customer_role_arn = module.wiz.role_arn
  }
  extra_config {
    audit_log_monitor_enabled = true
    skip_organization_scan    = true
    scheduled_security_tool_scanning_settings {
    enabled = true
    public_buckets_scanning_enabled = true
    }
    cloud_trail_config {
      bucket_name        = var.cloudtrail_bucket_name
    }
  }
}
