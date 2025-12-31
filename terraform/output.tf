output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.s3-website-configuration.website_endpoint
  description = "The S3 website endpoint"
}

output "s3-cloudfront-wndpoint" {
  value = aws_cloudfront_distribution.s3-website-distribution.domain_name
}

output "s3-cloudfront-aliases" {
  value = aws_cloudfront_distribution.s3-website-distribution.aliases
  description = "The list of alias domains associated with cloudfront distribution"
}