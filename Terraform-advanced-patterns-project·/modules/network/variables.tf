## Module: `modules/network` (purpose: create a small public VPC + SG for SSH/HTTP)


### `modules/network/variables.tf`


```hcl
variable "name" { 
  type = string 
}

variable "cidr_block" { 
  type = string 
}

  variable "public_subnet_cidr" { 
    type = string 
  }

  variable "allowed_cidr" { 
    type = string 
  }

  variable "tags" { 
    type = map(string) 
  }
