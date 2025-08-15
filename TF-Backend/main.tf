terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.7.0"
    }
  }
  backend "s3" {
    bucket = "tribhuvan357-demo-terraform-16866e55389ba3a8e5ab"
    key = "backend-bkp-tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

resource "aws_instance" "main" {
  ami = "ami-0d54604676873b4ec"
  instance_type = "t3.micro"
  count = 1
  key_name = "my-ec2-devops-terraform"


  root_block_device {
    volume_size = "20"
    volume_type = "gp2"
    delete_on_termination = "true"
  }

tags = {
    Name = "Test-Server"
}
}