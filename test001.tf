variable "bucket_configs" {
  type = map(object({    
    is_production = bool    
  }))
  default = {
    "678c5b75-761f-4ca6-9796-5d911460cd3c" = {      
      is_production = false      
    },
    "cbe172ae-a153-450a-98aa-0593b24a51cb" = {      
      is_production = true      
    },
    "33fedfcb-3952-4818-9c9e-992331714002" = {      
      is_production = true     
    }
  }
}




# Define a variable to hold the bucket names
variable "bucket_names" {
  description = "List of bucket names"
  type        = list(string)
  default     = ["678c5b75-761f-4ca6-9796-5d911460cd3c", "cbe172ae-a153-450a-98aa-0593b24a51cb", "33fedfcb-3952-4818-9c9e-992331714002"]
}

# Create multiple S3 buckets with tags based on lookup
resource "aws_s3_bucket" "buckets" {
  count         = length(var.bucket_names)
  bucket        = var.bucket_names[count.index]  
  force_destroy = true

  # Add tags based on the bucket name lookup
  tags = {
    Name        = var.bucket_names[count.index]
    Environment = lookup(var.bucket_configs, var.bucket_names[count.index]).is_production ? "prod" : "dev"
  }  
  
}