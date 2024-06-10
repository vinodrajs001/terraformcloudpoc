
provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-c2f70dfb-4d1a-40c2-b245-dff0effcfa1a" # Replace with your desired bucket name
  acl    = "private"               # Access control list (private, public-read, etc.)

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}
