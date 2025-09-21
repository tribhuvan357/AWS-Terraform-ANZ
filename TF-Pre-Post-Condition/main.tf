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

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "name" {
  name = "my-test-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami           = "ami-0d54604676873b4ec" # earlier it wad ami-0d54604676873b4ec but to test lifecycle we have changed it to ami-02d26659fd82cf299
  instance_type = "t3.micro"
  count         = 1
  key_name      = "my-ec2-devops-terraform"
  #vpc_security_group_ids = [aws_security_group.name.id] # attaching SG to ec2 instances
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false #make this value true or false to test condition 

  lifecycle {
    #create_before_destroy = true
    #prevent_destroy = true
    #ignore_changes => Refer to the same of lifecycle of IAM user login profile's lifecycle ignore changes password length
    #replace_triggered_by = [aws_security_group.name, aws_security_group.name.ingress]
    precondition {
      condition     = aws_security_group.name.id != ""
      error_message = "Security group id must not be blank"
    }

    postcondition {
      condition     = self.public_ip != ""
      error_message = "Public IP should not be blank"
    }

  }


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
