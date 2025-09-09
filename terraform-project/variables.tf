variable "region" {
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "instance_count" { type = number }
variable "instance_type"  { type = string }
variable "key_name"       { type = string }

variable "db_name"     { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string sensitive = true }
