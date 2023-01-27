# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "lab1-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "dev-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "lab1-public-subnet" {
  vpc_id                  = aws_vpc.lab1-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  #   availability_zone = "us-east-1a"

  tags = {
    Name        = "dev-public-subnet"
    Terraform   = "true"
    Environment = "dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "lab1-internet-gateway" {
  vpc_id = aws_vpc.lab1-vpc.id

  tags = {
    Name        = "dev-igw"
    Terraform   = "true"
    Environment = "dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "lab1-route-table" {
  vpc_id = aws_vpc.lab1-vpc.id

  # Default route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab1-internet-gateway.id
  }

  tags = {
    Name        = "dev-route-table"
    Terraform   = "true"
    Environment = "dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "lab1-route-table-association-subnet1" {
  subnet_id      = aws_subnet.lab1-public-subnet.id
  route_table_id = aws_route_table.lab1-route-table.id
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "lab1-security-group" {
  name        = "dev-sg"
  description = "Lab1 security group"
  vpc_id      = aws_vpc.lab1-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["142.181.71.211/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}