terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 3.0"
    }
  }
  backend "s3" {
    bucket = "blue-tf-state"
    key = "platform.tfstate"
    region = "ap-southeast-1"
  }
}

