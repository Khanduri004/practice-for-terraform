terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "iac-best-practices/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
