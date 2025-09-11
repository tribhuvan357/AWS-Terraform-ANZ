terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  users_data = yamldecode(file("./users.yaml")).users

  user_role_pair = flatten([for user in local.users_data : [for role in user.roles : {
    username = user.username
  role = role }]])
}

# Creating users
resource "aws_iam_user" "main" {
  for_each = toset(local.users_data[*].username) # Toset is used here to convet the username value to set whih is used by for_each.
  name     = each.value
}

# Password creation
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile
resource "aws_iam_user_login_profile" "main" {
  for_each        = aws_iam_user.main
  user            = each.value.name
  password_length = 8

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}


#Attaching policies
resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }

  user       = aws_iam_user.main[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}


output "User-Name" {
  value = local.users_data[*].username
}



