# IAM Role
resource "aws_iam_role" "custom_role" {
  name = "custom-role"
  
  # Reference the trust policy JSON file
  assume_role_policy = file("${path.module}/trust-policy.json")

  tags = {
    Environment = "Production"
    Purpose     = "Custom Role"
  }
}

# IAM Policy
resource "aws_iam_role_policy" "custom_policy" {
  name = "custom-policy"
  role = aws_iam_role.custom_role.id
  
  # Reference the role policy JSON file
  policy = file("${path.module}/role-policy.json")
}

# Output the role ARN
output "role_arn" {
  value = aws_iam_role.custom_role.arn
}
