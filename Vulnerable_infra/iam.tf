
resource "aws_iam_role" "ragserver_role" {
  name = "ragserver_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "vectordbserver_role" {
  name = "vectordbserver_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ragserver_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ragserver_role.name
}

resource "aws_iam_role_policy" "ragserver_role_policy" {
  name = "ragserver_policy"
  role = aws_iam_role.ragserver_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Terraform0"
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:ListRoles",
          "iam:ListUsers",
          "iam:ListGroups",
          "iam:GetRolePolicy"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
      },
      {
        "Sid": "AccessBucket",
        "Effect": "Allow",
        "Action": ["s3:*"],
        "Resource": [module.sensitive_bucket.bucket_arn]
        #"Resource": ["*"]
      },
      {
        "Sid": "AccessBucketObjects",
        "Effect": "Allow",
        "Action": ["s3:*"],
        "Resource": ["${module.sensitive_bucket.bucket_arn}/*"]
        #"Resource": ["*"]
      }
    ]
    }
  )
}

resource "aws_iam_role_policy" "vectordbserver_role_policy" {
  name = "vectordbserver_policy"
  role = aws_iam_role.vectordbserver_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Terraform0"
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:ListRoles",
          "iam:ListUsers",
          "iam:ListGroups",
          "iam:GetRolePolicy"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
      }
    ]
  }
  )
}

resource "aws_iam_policy_attachment" "ragserver_policy_attachment" {
  name       = "ragserver_policy_attachment"
  roles      = [aws_iam_role.ragserver_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "vectordbserver_policy_attachment" {
  name       = "vectordbserver_policy_attachment"
  roles      = [aws_iam_role.vectordbserver_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "ragserver_instance_profile" {
  name = "ragserver_role"
  role = aws_iam_role.ragserver_role.name
}

resource "aws_iam_instance_profile" "vectordbserver_instance_profile" {
  name = "vectordbserver_role"
  role = aws_iam_role.vectordbserver_role.name
}

resource "aws_iam_role" "instance_connect_role" {
  name = "dev_instance_connect_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "${aws_iam_role.ragserver_role.arn}",
            "${aws_iam_role.vectordbserver_role.arn}",
            ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "instance_connect_role_policy" {
  name = "dev_instance_connect_policy"
  role = aws_iam_role.instance_connect_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
            "Effect": "Allow",
            "Action": "ec2-instance-connect:SendSSHPublicKey",
            "Resource": "${module.aws_rag_instance.instance_arn}",
            "Condition": {
                "StringEquals": {
                    "ec2:osuser": "ubuntu"
                }
            }
        },
        {
          "Effect": "Allow",
          "Action": "ec2-instance-connect:SendSSHPublicKey",
          "Resource": "${module.aws_vectordb_instance.instance_arn}",
          "Condition": {
            "StringEquals": {
              "ec2:osuser": "ubuntu"
            }
          }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        }
    ]
}
  )
}