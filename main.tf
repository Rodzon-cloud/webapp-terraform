
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0a8b4cd432b1c3063"
  count         = 1
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0bd76875e860569a9"]
  subnet_id              = "subnet-0a41ebc7260114f95"

  tags = {
    Name = "AppInstance"
  }
  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd.x86_64
        systemctl start httpd.service
        systemctl enable httpd.service
        echo "Hello World Apache from $(hostname -f)" > /var/www/html/index.html
    EOF
}
