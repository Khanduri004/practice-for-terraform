data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
  actions = ["sts:AssumeRole"]
  principals {
  type = "Service"
  identifiers = ["ec2.amazonaws.com"]
  }
 }
}


resource "aws_iam_role" "ec2_role" {
  name = "${var.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = var.tags
}


# Inline policy allowing read of the specific secret
resource "aws_iam_role_policy" "secrets_read" {
  name = "${var.name_prefix}-secrets-read"
  role = aws_iam_role.ec2_role.id
 policy = jsonencode({
 Version = "2012-10-17",
  Statement = [
   {
    Action = [
     "secretsmanager:GetSecretValue",
     "secretsmanager:DescribeSecret"
   ],
   Effect = "Allow",
   Resource = var.secret_arn
  }
 ]
})
}


resource "aws_iam_instance_profile" "ec2_profile" {
name = "${var.name_prefix}-instance-profile"
role = aws_iam_role.ec2_role.name
}


output "instance_profile_name" { value = aws_iam_instance_profile.ec2_profile.name }
output "instance_role_arn" { value = aws_iam_role.ec2_role.arn
