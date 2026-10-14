resource "aws_vpc" "production" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "production"
  }

}
resource "aws_vpc" "staging" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "staging"
  }

}
resource "aws_vpc" "test" {
  cidr_block = "10.30.0.0/16"

  tags = {
    Name = "test"
  }

}
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.production.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.production.id

  tags = {
    Name = "internet-gateway"
  }
}
resource "aws_subnet" "production-private-subnet" {
  vpc_id            = aws_vpc.production.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "production-private-subnet"
  }
}
resource "aws_subnet" "staging-private-subnet" {
  vpc_id            = aws_vpc.staging.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "staging-private-subnet"
  }
}
resource "aws_subnet" "test-private-subnet" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.30.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "test-private-subnet"
  }
}
resource "aws_ec2_transit_gateway" "tgw" {

  tags = {
    Name = "transit-gateway"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "production-attachment" {

  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  vpc_id = aws_vpc.production.id

  subnet_ids = [
    aws_subnet.production-private-subnet.id
  ]

  tags = {
    Name = "production-tgw-attachment"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "staging-attachment" {

  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  vpc_id = aws_vpc.staging.id

  subnet_ids = [
    aws_subnet.staging-private-subnet.id
  ]

  tags = {
    Name = "staging-tgw-attachment"
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "test-attachment" {

  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  vpc_id = aws_vpc.test.id

  subnet_ids = [
    aws_subnet.test-private-subnet.id
  ]

  tags = {
    Name = "test-tgw-attachment"
  }
}
resource "aws_route_table" "public-rt" {

  vpc_id = aws_vpc.production.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
route {
  cidr_block         = "10.20.0.0/16"
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

route {
  cidr_block         = "10.30.0.0/16"
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}
  tags = {
    Name = "public-rt"
  }
}
resource "aws_route_table" "production-rt" {

  vpc_id = aws_vpc.production.id
  route {
    cidr_block         = "10.20.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block         = "10.30.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "production-rt"
  }
}
resource "aws_route_table" "staging-rt" {

  vpc_id = aws_vpc.staging.id
  route {
    cidr_block         = "10.10.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block         = "10.30.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "staging-rt"
  }
}
resource "aws_route_table" "test-rt" {

  vpc_id = aws_vpc.test.id
  route {
    cidr_block         = "10.10.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block         = "10.20.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "test-rt"
  }
}
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "production-rt-association" {
  subnet_id      = aws_subnet.production-private-subnet.id
  route_table_id = aws_route_table.production-rt.id

}
resource "aws_route_table_association" "staging-rt-association" {
  subnet_id      = aws_subnet.staging-private-subnet.id
  route_table_id = aws_route_table.staging-rt.id

}
resource "aws_route_table_association" "test-rt-association" {
  subnet_id      = aws_subnet.test-private-subnet.id
  route_table_id = aws_route_table.test-rt.id

}