provider "aws" {
  region =  "eu-north-1"
  access_key = "AKIAZ24ISSJ3F7FKVB5M"
  secret_key = "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"
}


resource "aws_vpc" "terraform-lab-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-lab-vpc"
  }
}
variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}
