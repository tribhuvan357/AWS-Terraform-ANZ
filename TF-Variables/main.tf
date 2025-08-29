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

resource "aws_instance" "main" {
  ami           = "ami-04dfaf32f72ea3fc1"
  instance_type = var.my_instance_type
  key_name      = "my-ec2-devops-terraform"

  root_block_device {
    delete_on_termination = true
    volume_size           = var.my_root_block_device.v_size
    volume_type           = var.my_root_block_device.v_type
  }

  tags = {
    Name = "Variable-Test-Server"
  }
}
