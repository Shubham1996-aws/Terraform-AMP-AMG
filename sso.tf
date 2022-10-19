data "aws_ssoadmin_instances" "ssouser" {}

data "aws_identitystore_user" "user" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.ssouser.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = var.username 
    }
  }
}

output "user_id" {
  value = data.aws_identitystore_user.user.user_id
}