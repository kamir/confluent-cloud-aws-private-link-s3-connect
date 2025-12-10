resource "aws_s3_bucket" "bucket" {
  bucket = "${local.resource_prefix}-bucket"

  tags = {
    Name        = "${local.resource_prefix}-bucket"
  }
  lifecycle {
    prevent_destroy = false # Change to true in production
  }
}

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.bucket.id
#   acl    = "private"

#   lifecycle {
#     prevent_destroy = false # Change to true in production
#   }
# }

resource "aws_s3_bucket_public_access_block" "bucket_restrict_public" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  lifecycle {
    prevent_destroy = false # Change to true in production
  }
}
