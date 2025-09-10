output "instance_public_ips" {
  description = "Map of instance public IPs"
  value = module.compute.instance_public_ips
}

output "secret_arn" {
  value = module.secrets.secret_arn
}
