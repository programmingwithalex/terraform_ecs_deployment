################################################################################
# VPC: Main Virtual Private Cloud for ECS and ALB
################################################################################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true  # needed for ECS service discovery
  enable_dns_hostnames = true  # needed for ECS service discovery

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

################################################################################
# Internet Gateway: Allows public subnets to access the internet
################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

################################################################################
# Public Subnets: For ALB and NAT Gateway
################################################################################
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project_name}-public-${count.index}"
  }
}

################################################################################
# Private Subnets: For ECS tasks/services (no direct internet access)
################################################################################
resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project_name}-private-${count.index}"
  }
}

################################################################################
# Data Source: Get available AWS availability zones
################################################################################
data "aws_availability_zones" "available" {}
