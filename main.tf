## Cloud Provider ####################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

## Region ##############################################
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

## Instance Type  #############################
resource "aws_instance" "app_server" {
  ami           = "ami-0a8b4cd432b1c3063"
  count         = 2
  instance_type = "t2.micro"

## Security Group and Subnet  ####################
  vpc_security_group_ids = ["sg-0bd76875e860569a9"]
  subnet_id              = "subnet-0a41ebc7260114f95"

  tags = {
    Name = "WebAppInstance"
  }
## Configure an Apache Webserver via shell script #######
  user_data = <<-EOF
        #!/bin/bash
        yum update -y   ## Update each package already installed
        yum install -y httpd    ## Install Apache
        systemctl start httpd.service    ## Start Apache
        systemctl enable httpd.service   ## Start Apache whenever the instance starts up
        echo "Hello World Apache from $(hostname -f)" > /var/www/html/index.html
    EOF
}
