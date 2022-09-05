provider "aws" {
    region = "ap-southeast-1"
}

# Create the VPC
resource "aws_vpc" "main" {                # Creating VPC here
  cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"
tags = {                                  # Tagging the VPC
  Name = "Development-vpc"
  }
}

# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Development main IGW"
  }
}

# Subnets
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnetA" {
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = var.public_subnetA

  tags = {
    Name = "Development-public_subnetA"
  }
}

resource "aws_subnet" "public_subnetB" {
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block = var.public_subnetB

  tags = {
    Name = "Development-public_subnetB"
  }
}

# S3 Bucket
data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket" "development-alblogs" {
  bucket = "development-alblogs"
}

resource "aws_s3_bucket_acl" "development-alblogs_bucket_acl" {
  bucket = aws_s3_bucket.development-alblogs.id
  acl    = "log-delivery-write"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Development-mobile-bff-alb-security-group"
  vpc_id      = aws_vpc.main.id 

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Development-mobile-bff-alb-security-group"
  }
}

resource "aws_lb" "dev-mobile-bff-alb-01" {
  name               = "dev-mobile-bff-alb-01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = ["${aws_subnet.public_subnetA.id}", "${aws_subnet.public_subnetB.id}"]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.development-alblogs.id
    prefix  = "Development-alb"
    enabled = false
  }

  tags = {
    Environment = "Development-mobile-bff-alb"
  }
}

