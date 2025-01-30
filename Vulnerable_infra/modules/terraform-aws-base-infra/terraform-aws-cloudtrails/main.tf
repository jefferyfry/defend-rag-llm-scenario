resource "aws_cloudtrail" "defend" {
  depends_on = [ aws_s3_bucket_policy.defend]
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.defend.bucket
  enable_logging                = var.enable_logging
  is_multi_region_trail         = var.multi_region
  include_global_service_events = var.global_service
  event_selector {
    read_write_type           = "All"
    include_management_events = true

  data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }
  tags                          = var.tags
}

resource "aws_s3_bucket" "defend" {
#  count = var.add_s3_bucket == "true" ? 1 : 0
  bucket        = "${var.s3_bucket_name}-ctf-trail"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "defend" {
#  count = var.add_s3_bucket == "true" ? 1 : 0
  bucket = aws_s3_bucket.defend.bucket
  policy = data.aws_iam_policy_document.defend.json
}

data "aws_iam_policy_document" "defend" {
#
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.defend.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.cloudtrail_name}"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.defend.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.cloudtrail_name}"]
    }
  }
}
