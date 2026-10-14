resource "aws_security_group" "production-sg" {
  name        = "production-security-group"
  description = "Allow ICMP from staging and test and SSH from bastion"
  vpc_id      = aws_vpc.production.id

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"

    cidr_blocks = [
      "10.20.0.0/16",
      "10.30.0.0/16"
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "test-sg" {
  name        = "test-security-group"
  description = "Allow ICMP from production and staging and SSH from bastion"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"

    cidr_blocks = [
      "10.10.0.0/16",
      "10.20.0.0/16"
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "staging-sg" {
  name        = "staging-security-group"
  description = "Allow ICMP from production and test and SSH from bastion"
  vpc_id      = aws_vpc.staging.id

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"

    cidr_blocks = [
      "10.10.0.0/16",
      "10.30.0.0/16"
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "bastion-sg" {
  name        = "bastion-security-group"
  description = "Allow SSH access to Bastion Host"
  vpc_id      = aws_vpc.production.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-security-group"
  }
}