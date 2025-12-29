output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.s3-website-configuration.website_endpoint
  description = "The S3 website endpoint"
}