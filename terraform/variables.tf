variable "region" {
  description = "AWS Region"
  default = "us-east-2"
}

variable "build_dir" {
  description = "The path to the website build directory"
  default = "../dist"
}