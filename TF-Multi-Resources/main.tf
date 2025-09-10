terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  region = "ap-south-1"
}

################################################### Task 1and 2 (count) ##################################################################

/*
locals {
  project = "Project-01"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.project}-VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  count      = 2
  tags = {
    Name = "${local.project}-Subnet-${count.index}"
  }
}

# Creating 4 EC2 instances
resource "aws_instance" "main" {
  ami           = "ami-0861f4e788f5069dd"
  instance_type = "t3.micro"
  count         = 4
  subnet_id     = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))
  #0%2=0
  #1%2=1
  #2%2=0
  #3%2=1

  tags = {
    Name = "${local.project}-instance-${count.index}"
  }
}


output "VPC-Name" {
  value = aws_vpc.main.id
}

output "Subnet-Output" {
  value = aws_subnet.main[*].id
}

output "EC2-Output" {
  value = aws_instance.main[*].id
}
*/

################################################## Task 3 (count) 2 server OS (ubuntu and amazon in both subnet)###################
####### Note:- Either run above code alone or below this command with variables.tf and terraform.tfvars
locals {
  project = "Project-01"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.project}-VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  count      = 2
  tags = {
    Name = "${local.project}-Subnet-${count.index}"
  }
}

# Creating 4 EC2 instances
resource "aws_instance" "main" {
  ami           = var.ec2_config[count.index].ami
  instance_type = var.ec2_config[count.index].instance_type
  count         = length(var.ec2_config)
  subnet_id     = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))
  #0%2=0
  #1%2=1

  tags = {
    Name = "${local.project}-instance-${count.index}"
  }
}


output "VPC-Name" {
  value = aws_vpc.main.id
}

output "Subnet-Output" {
  value = aws_subnet.main[*].id
}

output "EC2-Output" {
  value = aws_instance.main[*].id
}