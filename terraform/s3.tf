resource "aws_s3_bucket" "Sept_bucket" {
  bucket = "Sept_bucket"

  tags = {
    Name        = "Sept_bucket"
    Environment = "Dev"
  }
}
