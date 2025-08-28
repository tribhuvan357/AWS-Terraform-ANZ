resource "aws_security_group" "nginx-sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow SSH (restrict in real use)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow HTTP
  }

  egress {
    from_port   = 0             # all port
    to_port     = 0             # all port
    protocol    = "-1"          # all protocol
    cidr_blocks = ["0.0.0.0/0"] # to all ips
  }

  tags = {
    Name = "nginx-sg"
  }

}