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

  error_document {
    key = "index.html"
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

data "aws_iam_policy_document" "s3-website-public-policy-document" {
  statement {
    sid = "AllowCloudFrontServiceRead"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [ "cloudfront.amazonaws.com" ]
    }

    actions = [ 
        "s3:GetObject"
    ]

    resources = [ 
        "${aws_s3_bucket.s3-website-bucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3-website-distribution.arn]
    }
  }
}

# Allow public access to Get all files in the bucket
resource "aws_s3_bucket_policy" "s3-website-public-policy" {
  bucket = aws_s3_bucket.s3-website-bucket.id
  policy = data.aws_iam_policy_document.s3-website-public-policy-document.json
}