output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.testinstance.public_ip

output "private_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.testinstance.public_ip
}
}
