resource "aws_dynamodb_table" "my_table" {
  name = "${var.prefix}-items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"


attribute {
  name = "id"
  type = "S"
}


ttl {
  attribute_name = "expiresAt"
  enabled = true
}


tags = { Name = "${var.prefix}-dynamo" }
}
