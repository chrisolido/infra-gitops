provider "aws" {
    region = "ap-southeast-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

terraform {
  required_providers {
    aws = {
        sourcesource = "hashicorp/aws"
        versionversion = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "blue-tf-state"
    key = "platform.tfstate"
    region = "ap-southeast-1"
  }
}

# Create the VPC
resource "aws_vpc" "Main" {                # Creating VPC here
  cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"
tags = {                                  # Tagging the VPC
  Name = "Development"
}
} 
