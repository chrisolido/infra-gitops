
# AWS Credential
#variable "access_key" {}
#variable "secret_key" {}

# AWS NETWORKS
#variable "vpc_name" {
#  description = "Development of VPC"
#  type        = string
#  default     = "main"
#}

variable "main_vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.31.0.0/16"  
}
variable "public_subnetA" {}
variable "public_subnetB" {}
variable "private_subnetA" {}
variable "private_subnetB" {}


#variable "vpc_azs" {
#  description = "Availability zones for VPC"
#  type        = list(string)
#  default     = ["ap-southeast-1a", "ap-southeast-1b"]
#}
#
#variable "vpc_private_subnets" {
#  description = "Private subnets for VPC"
#  type        = list(string)
#  default     = ["172.31.3.0/24", "172.31.4.0/24"]
#}
#
#variable "vpc_public_subnets" {
#  description = "Public subnets for VPC"
#  type        = list(string)
#  default     = ["172.31.1.0/24", "172.31.2.0/24"]
#}
#
#variable "vpc_enable_nat_gateway" {
#  description = "Enable NAT gateway for VPC"
#  type        = bool
#  default     = true
#}
#
#variable "vpc_tags" {
#  description = "Tags to apply to resources created by VPC module"
#  type        = map(string)
#  default = {
#    Terraform   = "true"
#    Environment = "Development"
#  }
#}

