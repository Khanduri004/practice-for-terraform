# 1. find a recent Amazon Linux 2 AMI (keeps code portable across regions)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]
  filter {
  name = "name"
  values = ["amzn2-ami-hvm-*-x86_64-gp2"]
}
}

# 2. network module
module "network" {
 source = "./modules/network"
 name = "demo-network"
 cidr_block = "10.0.0.0/16"
 public_subnet_cidr = "10.0.1.0/24"
 allowed_cidr = var.allowed_cidr
 tags = local.common_tags
}


# 3. secrets module (creates a Secrets Manager secret for demo)
module "secrets" {
 source = "./modules/secrets"
 name = "demo-secret"
 description = "Demo secret for Terraform learning"
 secret_value = var.demo_secret_value
 tags = local.common_tags
}


# 4. IAM module: creates an instance role + instance profile which will allow
# EC2 instances to read Secrets Manager (so they can fetch the secret at runtime)
module "iam" {
  source = "./modules/iam"
  name_prefix = "demo-ec2"
  secret_arn = module.secrets.secret_arn
  tags = local.common_tags
}


# 5. compute module: create EC2 instances dynamically using for_each (a map)
module "compute" {
 source = "./modules/compute"
 instances = var.instances
 ami_id = data.aws_ami.amazon_linux_2.id
 subnet_id = module.network.public_subnet_id
 security_group_id = module.network.security_group_id
 instance_profile = module.iam.instance_profile_name
 public_key_path = var.public_key_path
 private_key_path = var.private_key_path
 secret_arn = module.secrets.secret_arn
 tags = local.common_tags
 aws_region = var.aws_region
}
