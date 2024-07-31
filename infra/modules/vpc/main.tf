resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-tenant-management-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.available)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available[count.index]

  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(data.aws_availability_zones.available)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(data.aws_availability_zones.available))
  availability_zone = data.aws_availability_zones.available[count.index]

  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
  }
}

# Add other VPC components like Internet Gateway, NAT Gateway, Route Tables, etc.
