terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }

  }
  backend "s3" {
    bucket = "pizzadev-terraform-state"
    key = "terraform/local" 
    region = "us-east-2"
  }  
}

provider "aws" {
  region = var.region
}