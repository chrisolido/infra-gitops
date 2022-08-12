provider "aws" {
    region = "ap-southeast-1"
}

terraform {
  required_providers {
    aws = {
        sourcesource = "hashicorp/aws"
        versionversion = "~>3.0"
    }
  }
  backend "s3" {
    bucket = "blue-tf-state"
    key = "platform.tfstate"
    region = "ap-southeast-1"
  }
}