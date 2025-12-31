# Load the domain certificates from ACM
data "aws_acm_certificate" "domain-cert" {
  region = "us-east-1"
  domain = var.domain
}