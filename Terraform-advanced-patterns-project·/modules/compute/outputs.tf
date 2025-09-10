output "instance_public_ips" { value = { for k, i in aws_instance.web : k => i.public_ip } }
