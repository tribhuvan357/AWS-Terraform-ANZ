# Creating Public EC2 instance for testing purpose
resource "aws_instance" "nginx-server" {
  ami                         = "ami-0d54604676873b4ec"
  instance_type               = "t3.micro"
  key_name                    = "my-ec2-devops-terraform"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }



  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              # Overwrite the default Nginx index page
              echo "<h1>Hello from Terraform + Amazon Linux 2023 + Nginx (with sudo)</h1>" | sudo tee /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Nginx-Server-MyVPC"
  }
}
