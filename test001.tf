# Create IAM Group
resource "aws_iam_group" "workspace_users" {
  name = "workspace-users"
  path = "/"
}

# Define policy document using templatefile
data "aws_iam_policy_document" "AWS_111111_WorkspaceUsers_inline_policy" {
  source_policy_documents = [
    templatefile("${path.module}/permission_inline_policies/AWS_111111_WorkspaceUsers_inline_policy.json.tftpl", {
      zscaler_ips = local.zscaler_ips
    })
  ]
}

# Create IAM Policy
resource "aws_iam_policy" "workspace_users" {
  name        = "workspace-users-policy"
  description = "Policy for Workspace users with Zscaler IP restrictions"
  policy      = data.aws_iam_policy_document.AWS_111111_WorkspaceUsers_inline_policy.json.tftpl
}

# Attach policy to the group
resource "aws_iam_group_policy_attachment" "workspace_users" {
  group      = aws_iam_group.workspace_users.name
  policy_arn = aws_iam_policy.workspace_users.arn
}

# Optionally, add users to the group
resource "aws_iam_user_group_membership" "workspace_users" {
  user = aws_iam_user.example.name
  groups = [aws_iam_group.workspace_users.name]
}

# Optional: Create IAM users
resource "aws_iam_user" "example" {
  name = "workspace-user-1"
  path = "/"
}

# Optional: Add more users if needed
resource "aws_iam_user" "additional_users" {
  count = length(var.workspace_users)
  name  = var.workspace_users[count.index]
  path  = "/"
}

# Optional: Add multiple users to the group
resource "aws_iam_group_membership" "workspace_team" {
  name  = "workspace-team-membership"
  users = concat([aws_iam_user.example.name], aws_iam_user.additional_users[*].name)
  group = aws_iam_group.workspace_users.name
}

# Variables
variable "workspace_users" {
  type        = list(string)
  description = "List of workspace users to create"
  default     = ["user1", "user2", "user3"]
}

locals {
  zscaler_ips = [
    "203.0.113.0/24",
    "198.51.100.0/24",
    "192.0.2.0/24"
  ]
}
