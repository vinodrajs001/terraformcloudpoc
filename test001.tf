# Define local variables
locals {
  zscaler_ips = [
    "203.0.113.0/24",
    "198.51.100.0/24",
    "192.0.2.0/24"
  ]
}
resource "aws_iam_group" "workspace_users" {
  name = "workspace-users"
  path = "/"
}

# Create policy document using templatefile
data "aws_iam_policy_document" "AWS_111111_WorkspaceUsers_inline_policy" {
  source_policy_documents = [
    templatefile("${path.module}/permission_inline_policies/AWS_111111_WorkspaceUsers_inline_policy.json", {
      zscaler_ips = local.zscaler_ips
    })
  ]
}

# Create the IAM policy
resource "aws_iam_policy" "workspace_users" {
  name        = "workspace-users-policy"
  description = "Policy for Workspace users with Zscaler IP restrictions"
  policy      = data.aws_iam_policy_document.AWS_111111_WorkspaceUsers_inline_policy.json
}

# Attach policy to a group
resource "aws_iam_group_policy_attachment" "workspace_users" {
  group      = aws_iam_group.workspace_users.name
  policy_arn = aws_iam_policy.workspace_users.arn
}
