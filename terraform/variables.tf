variable "region" {
  description = "AWS Region"
  default = "us-east-2"
}

variable "build_dir" {
  description = "The path to the website build directory"
  default = "../dist"
}

variable "domain" {
  description = "The domain name for the static website"
  default = "zakariatalhami.dev"
}

variable "app_name" {
    description = "The application name. Will be used as the CNAME name in DNS"
    default = "cloudfront-dis"
}