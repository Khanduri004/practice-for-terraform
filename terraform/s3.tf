resource "aws_kms_key" "Sept_Key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "Sept_bucket" {
  bucket = "Sept_bucket"

  tags = {
    Name        = "Sept_bucket"
    Environment = "Dev"
  }

resource "aws_s3_bucket_server_side_encryption_configuration" "Sept_Month" {
  bucket = aws_s3_bucket.Sept_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.Sept_Key.arn
      sse_algorithm     = "aws:kms"
    }
  }

 resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.Sept_bucket_id
  versioning_configuration {
    status = "Enabled"
  }
}
}
