
provider "aws" {
  region = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}


variable "environment" {
  description = "The environment (e.g., development, staging, production)"
  type        = string
  default = "development"
}

locals {
  billing_mode = {
    development = "PAY_PER_REQUEST"
    staging     = "PAY_PER_REQUEST"
    production  = "PROVISIONED"
  }

  read_capacity = local.billing_mode[var.environment] == "PROVISIONED" ? 10 : null
  write_capacity = local.billing_mode[var.environment] == "PROVISIONED" ? 10 : null
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = local.billing_mode[var.environment]
  hash_key       = "sk"

  
  read_capacity  = local.read_capacity
  write_capacity = local.write_capacity

  
}