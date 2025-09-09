module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "ec2" {
  source = "./modules/ec2"

  instance_count = var.instance_count
  instance_type  = var.instance_type
  subnet_id      = element(module.vpc.public_subnet_ids, 0)
  key_name       = var.key_name
}

module "rds" {
  source = "./modules/rds"

  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
  subnet_ids    = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.vpc.default_sg_id]
}
