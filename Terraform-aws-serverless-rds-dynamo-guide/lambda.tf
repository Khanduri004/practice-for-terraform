data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}


resource "aws_lambda_function" "api_lambda" {
  function_name = "${var.prefix}-api-handler"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = "handler.lambda_handler"
  runtime = "python3.10"
  role = aws_iam_role.lambda_role.arn

  environment {
   variables = {
   TABLE_NAME = aws_dynamodb_table.my_table.name
   }
 }

depends_on = [aws_iam_role_policy_attachment.lambda_basic_attach, aws_iam_role_policy_attachment.lambda_dynamodb_attach]
}
