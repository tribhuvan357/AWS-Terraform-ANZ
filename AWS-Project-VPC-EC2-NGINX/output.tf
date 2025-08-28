output "Terraform-VPC-ID" {
  value = aws_vpc.main.id
}

output "Terraform-VPC-Public-Subnet-ID" {
  value = aws_subnet.public.id
}

output "Terraform-VPC-Private-Subnet-ID" {
  value = aws_subnet.private.id
}

output "Terraform-VPC-IGW" {
  value = aws_internet_gateway.main.id
}

output "Terraform-VPC-Routing-Table" {
  value = aws_route_table.main.id
}

output "Terraform-Nginx-EC2-Server-InstanceID" {
  value = aws_instance.nginx-server.id
}

output "Terraform-Nginx-Server-IP" {
  value = aws_instance.nginx-server.public_ip
}

output "Terraform-Nginx-Server-URL" {
  value = "http://${aws_instance.nginx-server.public_ip}"
}