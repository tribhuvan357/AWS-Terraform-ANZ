terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
  # region = var.region
}

resource "aws_security_group" "name" {
  name = "my-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami                    = "ami-0d54604676873b4ec"
  instance_type          = "t3.micro"
  count                  = 1
  key_name               = "my-ec2-devops-terraform"
  vpc_security_group_ids = [aws_security_group.name.id] # attaching SG to ec2 instances
  depends_on             = [aws_security_group.name]


  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }

  tags = {
    Name = "Test-Server"
  }
}


output "aws_instance_public_ip" {
  value = aws_instance.main[0].public_ip
}

output "aws_instance_server_ami" {
  value = aws_instance.main[0].ami
}

output "aws_instance_id" {
  value = [for instance in aws_instance.main : instance.id] # If we use count
}
