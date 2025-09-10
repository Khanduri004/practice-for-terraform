```hcl
resource "aws_secretsmanager_secret" "this" {
  name = var.name
  description = var.description
  tags = var.tags
}


resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = var.secret_value
}


output "secret_arn" {
value = aws_secretsmanager_secret.this.arn
}
```


> **Security note**: `aws_secretsmanager_secret_version.secret_string` 
will put the secret value into the Terraform state file in plaintext. For local practice this is OK, 
but in production **don’t** put real secrets in Terraform variables. Instead create secrets out-of-band (CLI/console) and 
 reference them via data sources or use a separate secrets pipeline.
