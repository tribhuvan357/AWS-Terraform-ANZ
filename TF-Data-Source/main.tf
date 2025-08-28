terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#Note:- Data source are specific to same account, same cloud infrastructure and region  

data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "data-source-aws-ami" {
  value = data.aws_ami.name.id
  # value = data.aws_ami.name # use this to get more info
}

resource "aws_instance" "nginx-server" {
  ami = data.aws_ami.name.id
  #ami = "ami-0d54604676873b4ec" #uncomment this to perform this and comment the above one at same time
  instance_type   = "t3.micro"
  key_name        = "my-ec2-devops-terraform"
  subnet_id       = data.aws_subnet.name.id
  security_groups = [data.aws_security_group.name.id]

  tags = {
    Name = "Nginx-Server-MyVPC"
  }
}

# Note: It might occur charges so be wise (Do Terraform plan only)

# Securuty Group
data "aws_security_group" "name" {
  tags = {
    Name = "My-SG"
  }
}

output "SG-ID" {
  value = data.aws_security_group.name.id
  # value = data.aws_security_group.name # use this to get more info
}

#VPC ID
data "aws_vpc" "name" {
  tags = {
    Name = "AWS-Default-VPC"
  }
}

output "VPC-ID" {
  value = data.aws_vpc.name.id
  #  value = data.aws_vpc.name # use this to get more info
}

#AZ
data "aws_availability_zones" "name" {
  state = "available"
}

output "aws_zones" {
  value = data.aws_availability_zones.name
}

#To get the subnet ID
data "aws_subnet" "name" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.name.id]
  }
  tags = {
    Name = "AWS-Default-VPC-Subnet-1"
  }
}

output "subnet-id" {
  value = data.aws_subnet.name
}

# To get the current account details
data "aws_caller_identity" "name" {

}

output "caller_info" {
  value = data.aws_caller_identity.name
}

# To get the aws current region
data "aws_region" "name" {

}

output "region_name" {
  value = data.aws_region.name
}