output "aws_instance_public_ip" {
 value =   aws_instance.main[0].public_ip
}

output "aws_instance_server_ami" {
  value = aws_instance.main[0].ami
}

output "aws_instance_id" {
  value = [for instance in aws_instance.main : instance.id] # If we use count
}