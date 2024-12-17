# Variables
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Create policy using templatefile
resource "aws_iam_policy" "template_policy" {
  name        = "template-policy"
  description = "Policy created from template file"
  
  policy = templatefile("${path.module}/trust-policy.json", {
    bucket_name = var.bucket_name
    table_name  = var.table_name
    environment = var.environment
    region      = data.aws_region.current.name
    account_id  = data.aws_caller_identity.current.account_id
  })
}
