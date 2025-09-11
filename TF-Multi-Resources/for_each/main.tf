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

# Creating 2 EC2 instances
#Note:- key=ubuntu and amazon and value=ami and instance type 
resource "aws_instance" "main" {
  for_each      = var.ec2_map
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = element(aws_subnet.main[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.main))
  #0%2=0
  #1%2=1

  tags = {
    Name = "${local.project}-instance-${each.key}"
  }
}


output "VPC-Name" {
  value = aws_vpc.main.id
}

output "Subnet-Output" {
  value = aws_subnet.main[*].id
}

output "EC2-Output" {
  value = { for k, v in aws_instance.main : k => v.id }  # With for_each, we need a map, not [*]
}