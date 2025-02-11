#IAM users

resource "aws_iam_user" "main" {
    for_each = toset(local.users_data[*].username)
    name = each.value
}

#Password

resource "aws_iam_user_login_profile" "password" {
    for_each = aws_iam_user.main
    user = each.value.name
    password_length = 10

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}


#Group

resource "aws_iam_group" "group" {
  for_each = toset([for user in local.users_data : user.group])
  name = each.key
}

#policies attachment

resource "aws_iam_user_policy_attachment" "iampolicy"{
    for_each = {
        for pair in local.users_role_pair:
        "${pair.username}-${pair.role}" => pair
    }

    #Ashok-EC2FullAccess = {username = Ashok, role = EC2FullAccess}

    user = aws_iam_user.main[each.value.username].name
    policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}


resource "aws_iam_user_group_membership" "iamgroup"{
    for_each = {for user in local.users_data : user.username => user}
    user   = aws_iam_user.main[each.value.username].name
    groups = [each.value.group]
  
}
