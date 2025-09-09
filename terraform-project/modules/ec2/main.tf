module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  count         = var.instance_count
  name          = "iac-instance-${count.index}"
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
}
