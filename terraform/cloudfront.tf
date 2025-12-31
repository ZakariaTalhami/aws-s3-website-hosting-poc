resource "aws_cloudfront_origin_access_control" "s3-oac" {
  name = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3-website-distribution" {
  enabled = true
  origin {
    domain_name = aws_s3_bucket.s3-website-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3-oac.id
    origin_id = "s3-origin"
    # custom_origin_config {
    #   http_port              = 80
    #   https_port             = 443
    #   origin_protocol_policy = "http-only"
    #   origin_ssl_protocols   = ["TLSv1"]
    # }
  }

  default_root_object = "index.html"

  aliases = [ "${var.app_name}.${var.domain}" ]

  default_cache_behavior {
    target_origin_id = "s3-origin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.domain-cert.arn
    ssl_support_method = "sni-only"
  }

  price_class = "PriceClass_200"
}