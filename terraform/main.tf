# Random UUID for unique bucket naming
resource "random_uuid" "name_uuid" {}

resource "aws_s3_bucket" "s3-website-bucket" {
  bucket = "static-website-poc-${random_uuid.name_uuid.result}"
}

resource "aws_s3_bucket_website_configuration" "s3-website-configuration" {
  bucket = aws_s3_bucket.s3-website-bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Disable the block public protection on the bucket
resource "aws_s3_bucket_public_access_block" "s3-public-access-block" {
  bucket = aws_s3_bucket.s3-website-bucket.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

# Allow public access to Get all files in the bucket
resource "aws_s3_bucket_policy" "s3-website-public-policy" {
  bucket = aws_s3_bucket.s3-website-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3-website-bucket.arn}/*"
      }
    ]
  })
}