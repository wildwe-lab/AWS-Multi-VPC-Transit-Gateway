resource "aws_instance" "production-servers" {

  ami           = "ami-066c4849e6b3a1e3d"
  instance_type = "t3.micro"
  key_name      = "access-key-pair"

  subnet_id = aws_subnet.production-private-subnet.id


  vpc_security_group_ids = [
    aws_security_group.production-sg.id
  ]

  tags = {
    Name = "production-servers"
  }
}
resource "aws_instance" "staging-servers" {

  ami           = "ami-066c4849e6b3a1e3d"
  instance_type = "t3.micro"
  key_name      = "access-key-pair"

  subnet_id = aws_subnet.staging-private-subnet.id

  vpc_security_group_ids = [
    aws_security_group.staging-sg.id
  ]

  tags = {
    Name = "staging-servers"
  }
}
resource "aws_instance" "test-servers" {

  ami           = "ami-066c4849e6b3a1e3d"
  instance_type = "t3.micro"
  key_name      = "access-key-pair"

  subnet_id = aws_subnet.test-private-subnet.id

  vpc_security_group_ids = [
    aws_security_group.test-sg.id
  ]

  tags = {
    Name = "test-servers"
  }
}
resource "aws_instance" "bastion-server" {
  ami           = "ami-066c4849e6b3a1e3d"
  instance_type = "t3.micro"
  key_name      = "access-key-pair"

  subnet_id = aws_subnet.public-subnet.id

  vpc_security_group_ids = [
    aws_security_group.bastion-sg.id
  ]

  tags = {
    Name = "bastion-server"
  }
}