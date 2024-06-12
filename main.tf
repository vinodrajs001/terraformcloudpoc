
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
# ----------------DO NOT CHANGE ABOVE CODE------------------------

variable "environment" {
  description = "The environment (e.g., development, staging, production)"
  type        = string
  default = "production"
}

locals {
  billing_mode = {
    development = "PAY_PER_REQUEST"
    staging     = "PAY_PER_REQUEST"
    production  = "PROVISIONED"

  environment = {
      development = {
        table1 = {
          billing_mode = "PAY_PER_REQUEST"                    
        }
        table2 = {
          billing_mode = "PROVISIONED"
        }
      }    
    }  
    production = {
      table1 = {
          billing_mode = "PROVISIONED"
          read_capacity = 10
          write_capacity = 10
        }
        table2 = {
          billing_mode = "PAY_PER_REQUEST"          
        }
      }    
    }
  
  
  read_capacity = local.billing_mode[var.environment] == "PROVISIONED" ? 10 : null
  write_capacity = local.billing_mode[var.environment] == "PROVISIONED" ? 10 : null
}

resource "aws_dynamodb_table" "table1" {
  name           = "table_name-${var.environment}"
  # billing_mode   = local.billing_mode[var.environment]
  billing_mode   = local.billing_mode[var.environment]["table1"].billing_mode
  hash_key       = "Id"  

  attribute {
      name = "Id"
      type = "S"
    }   
  
  # read_capacity  = local.read_capacity
  # write_capacity = local.write_capacity

  read_capacity  = local.read_capacity
  write_capacity = local.write_capacity
  
}

