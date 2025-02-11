terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

locals{
    users_data = yamldecode(file("./users.yaml")).users
    users_role_pair = flatten([for user in local.users_data: [for role in user.roles: {
        username = user.username
        role = role
    }]])
}

output "output" {
    value = local.users_role_pair
}

output "user_output" {
    value = local.users_data
}

