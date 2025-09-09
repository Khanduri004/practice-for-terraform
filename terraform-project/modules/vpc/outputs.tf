output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "default_sg_id" {
  value = module.vpc.default_security_group_id
}
