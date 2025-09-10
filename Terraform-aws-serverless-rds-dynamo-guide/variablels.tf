variable "region" {
  type = string
  default = "eu-west-1"
}


variable "prefix" {
  type = string
  default = "demo"
}


variable "db_username" {
  type = string
  default = "admin"
}


variable "db_instance_class" {
  type = string
  default = "db.t3.micro"
}


# Replace with your public IP/CIDR for SSH to the optional bastion when testing RDS.
variable "my_ip_cidr" {
  type = string
  default = "YOUR.IP.ADD.RESS/32"
}
  
