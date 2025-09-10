variable "instances" {
type = map(object({ instance_type = string, name = string }))
}


variable "ami_id" { type = string }
variable "subnet_id" { type = string }
variable "security_group_id" { type = string }
variable "instance_profile" { type = string }
variable "public_key_path" { type = string }
variable "private_key_path" { type = string }
variable "secret_arn" { type = string }
variable "tags" { type = map(string) }
variable "aws_region" { type = string }
