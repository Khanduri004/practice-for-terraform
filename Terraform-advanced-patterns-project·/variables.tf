variable "aws_region" {
  description = "AWS region for resources"
  type = string
  default = "eu-west-1"
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type = string
  default = "dev"
}


variable "owner" {
  description = "Owner tag"
  type = string
  default = "terraform-student"
}


variable "allowed_cidr" {
  description = "CIDR allowed to SSH into instances (set to your IP)"
  type = string
  default = "0.0.0.0/0" # change this in real usage
}

variable "public_key_path" {
  description = "Path to the public SSH key that will be uploaded as an AWS key pair"
  type = string
  default = "~/.ssh/terraform_key.pub"
}


variable "private_key_path" {
  description = "Path to the private SSH key for remote-exec connections (on your machine)"
  type = string
  default = "~/.ssh/terraform_key"
}


variable "instances" {
  description = "Map of instances to create (for_each)
  Each value is an object with attributes used by the compute module."
  type = map(object({
    instance_type = string
    name = string
    } ))
   default = {
    web-01 = {
    instance_type = "t3.micro"
    name = "web-01"
    }
    web-02 = {
    instance_type = "t3.micro"
    name = "web-02"
    }
  }
}


variable "tags" {
  type = map(string)
  default = {
  Project = "terraform-advanced-patterns"
  }
} 


# Sensitive secret used only for demo purposes. WARNING: putting real secrets here will persist them
# in Terraform state. See the notes in the README.
variable "demo_secret_value" {
  description = "Demo secret value to store in Secrets Manager (sensitive)"
  type = string
  sensitive = true
  default = "my-demo-secret-value"
}
