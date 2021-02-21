resource "aws_instance" "ec2-instance" {
  ami           = "ami-098828924dc89ea4a" #AmazonLinux2
  instance_type = "t2.micro"

  subnet_id = aws_subnet.itea-subpub3.id

  vpc_security_group_ids = [aws_security_group.itea-sg.id]

  key_name = "terraform_for"

  tags = {
    "Name" = "ec2-instance"
  }
}
