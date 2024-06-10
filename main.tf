provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0747bdcabd34c712a" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "Example Instance"
  }
}
