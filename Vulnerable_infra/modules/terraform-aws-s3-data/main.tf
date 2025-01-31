resource "aws_s3_bucket" "defend_bucket" {
  bucket = local.bucket_name

  tags = {
    Application = "Defend"
    Deployer    = "Terraform"
  }
}


resource "aws_s3_object" "defend_object" {
  for_each = fileset(path.module, "data/*")
  bucket = aws_s3_bucket.defend_bucket.id
  key    = each.key
  source = "${path.module}/${each.value}"
  etag   = filemd5("${path.module}/${each.value}")
}

resource "aws_s3_bucket_policy" "defend_bucket_policy" {
  bucket = aws_s3_bucket.defend_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "client-data-keys-default-statement",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            var.ragserver_role_arn,
          ]
        },
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.defend_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.defend_bucket.bucket}/*"
        ]
      }
    ]
  })
}