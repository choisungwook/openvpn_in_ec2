resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public" {
  for_each = var.public-subnets

  vpc_id                  = aws_vpc.main.id
  availability_zone       = each.value["az"]
  cidr_block              = each.value["cidr"]
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-test-public"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private-subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value["az"]
  cidr_block        = each.value["cidr"]

  tags = {
    Name = "terraform-test-private"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public["public-a"].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value["id"]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value["id"]
  route_table_id = aws_route_table.private.id
}
