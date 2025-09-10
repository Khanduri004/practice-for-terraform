variable "name" { type = string }
variable "description" { type = string }
variable "secret_value" { type = string, sensitive = true }
variable "tags" { type = map(string) }
