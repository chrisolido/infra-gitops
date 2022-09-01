provider "aws" {
    region = "ap-southeast-1"
#    access_key = var.access_key
#    secret_key = var.secret_key
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = var.vpc_name
  cidr = var.main_vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  #enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

## Create the VPC
resource "aws_vpc" "main" {                # Creating VPC here
  cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"
tags = {                                  # Tagging the VPC
  Name = "Development-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnetA" {
  vpc_id     = module.vpc.name
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = var.public_subnetA

  tags = {
    Name = "Development-public_subnetA"
  }
}

resource "aws_subnet" "public_subnetB" {
  vpc_id     = module.vpc.name
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block = var.public_subnetB

  tags = {
    Name = "Development-public_subnetB"
  }
}

resource "aws_s3_bucket" "development-alblogs" {
  bucket = "development-alblogs"

  tags = {
    Name        = "alb-logs"
    Environment = "Development"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Development-mobile-bff-alb-security-group"
  vpc_id      = module.vpc.name

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
  subnets            = module.vpc.public_subnets[*]
#  subnets            = ["${aws_subnet.public_subnetB.id}", "${aws_subnet.public_subnetB.id}"]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.development-alblogs.bucket
    prefix  = "Development-alb"
    enabled = true
  }

  tags = {
    Environment = "Development-mobile-bff-alb"
  }
}