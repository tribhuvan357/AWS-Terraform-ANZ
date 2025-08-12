provider "aws" {
  region = "ap-south-1" # or your preferred region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub") # make sure this exists
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow port 8080 for web server"

  ingress {
    description = "Allow HTTP on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 AMI for ap-south-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              echo "Hello from Terraform Web Server on port 8080" > /var/www/html/index.html
              sudo sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

  tags = {
    Name = "Terraform-Web-Server"
  }
}
