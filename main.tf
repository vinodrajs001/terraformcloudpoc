provider "github" {
  owner = "vinodrajs001"
  repository = "terraformcloudpoc"
}

data "github_actions_environment_secret" "aws_access_key_id" {
  environment     = "prod"
  secret_name     = "AKIAY4M62XUOSWSQUKMJ"
}

data "github_actions_environment_secret" "aws_secret_access_key" {
  environment     = "prod"
  secret_name     = "hE38NoUY8L33tMsudIi298wFik6i3LmRJvLKVdEv"
}

provider "aws" {
  region = "us-east-1"
  access_key = data.github_actions_environment_secret.aws_access_key_id.secret
  secret_key = data.github_actions_environment_secret.aws_secret_access_key.secret
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-c2f70dfb-4d1a-40c2-b245-dff0effcfa1a" # Replace with your desired bucket name
  acl    = "private"               # Access control list (private, public-read, etc.)

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}