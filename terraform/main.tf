terraform {
  backend "s3" {
    bucket = "terraform-045107234435"
    key    = "aws_health.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}