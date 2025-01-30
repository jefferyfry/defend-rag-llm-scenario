data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "instance_connect" {
  name = "com.amazonaws.${data.aws_region.current.name}.ec2-instance-connect"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


