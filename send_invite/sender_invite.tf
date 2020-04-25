variable rcenv {}
variable sender_share_arn {}
variable workspace_iam_roles {}
variable region {
  default = "us-west-2"
}

provider aws {
    alias  = "rcenv"
    region = var.region
    assume_role {
        role_arn = var.workspace_iam_roles[var.rcenv]
    }
    ignore_tag_prefixes = ["kubernetes.io/cluster/","kubernetes.io/role/"]
} 

## Send and accept invites to other account
resource "aws_ram_principal_association" "sender_invite" {
  #principal  = data.aws_caller_identity.receiver.account_id
  principal  = "995382439923"
  resource_share_arn = var.sender_share_arn
}

# resource "aws_ram_resource_share_accepter" "receiver_accept" {
#   provider = aws.rcenv
#   share_arn = aws_ram_principal_association.sender_invite.resource_share_arn
# }

# data "aws_caller_identity" "receiver" {
#   provider = aws.rcenv
# }