
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
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = local.billing_mode[var.environment]
  hash_key       = "HashKey"

   
  dynamic "read_capacity" {
    for_each = local.billing_mode[var.environment] == "PROVISIONED" ? [1] : []
    content {
      read_capacity  = 5
      write_capacity = 5
    }
  }  
}





