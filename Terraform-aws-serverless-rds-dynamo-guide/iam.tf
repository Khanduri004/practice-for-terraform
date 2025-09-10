resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
    Action = "sts:AssumeRole"
     Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
     }]
  })
}


# basic execution role for CloudWatch logs
resource "aws_iam_role_policy_attachment" "lambda_basic_attach" {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# limited policy for DynamoDB access
data "aws_iam_policy_document" "lambda_dynamodb_policy_doc" {
  statement {
   actions = [
    "dynamodb:PutItem",
    "dynamodb:GetItem",
    "dynamodb:Query",
    "dynamodb:Scan",
    "dynamodb:UpdateItem",
    "dynamodb:DeleteItem"
  ]

resources = [aws_dynamodb_table.my_table.arn]
effect = "Allow"
  }
}


resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "${var.prefix}-lambda-dynamodb"
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy_doc.json
}


resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
   role = aws_iam_role.lambda_role.name
   policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}
