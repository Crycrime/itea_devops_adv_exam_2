resource "aws_vpc" "itea-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"

  tags = {
    "Name" = "itea-vpc"
  }
}

resource "aws_subnet" "itea-subpub1" {
  vpc_id                  = aws_vpc.itea-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Public subnet 1"
  }
}

resource "aws_subnet" "itea-subpub2" {
  vpc_id                  = aws_vpc.itea-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "Public subnet 2"
  }
}

resource "aws_subnet" "itea-subpub3" {
  vpc_id                  = aws_vpc.itea-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2c"

  tags = {
    Name = "Public subnet 3"
  }
}

resource "aws_internet_gateway" "itea-igw" {
  vpc_id = aws_vpc.itea-vpc.id

  tags = {
    "Name" = "itea-igw"
  }
}

resource "aws_route_table" "itea-rt" {
  vpc_id = aws_vpc.itea-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.itea-igw.id
  }

  tags = {
    Name = "itea-rt"
  }
}

resource "aws_route_table_association" "itea-subpub-1-rt" {
  subnet_id      = aws_subnet.itea-subpub1.id
  route_table_id = aws_route_table.itea-rt.id
}

resource "aws_route_table_association" "itea-subpub-2-rt" {
  subnet_id      = aws_subnet.itea-subpub2.id
  route_table_id = aws_route_table.itea-rt.id
}

resource "aws_route_table_association" "itea-subpub-3-rt" {
  subnet_id      = aws_subnet.itea-subpub3.id
  route_table_id = aws_route_table.itea-rt.id
}

resource "aws_security_group" "itea-sg" {
  name   = "allow_http and ssh"
  vpc_id = aws_vpc.itea-vpc.id

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sec.group for 80 22"
  }
}
