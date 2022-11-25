# Create Users fpr each product to access the prefix
resource "aws_iam_user" "product_user"{
    for_each = toset(var.product_names)
    name = "${var.system_name}-user-chirag-${each.value}"
    /* path = "/" */
}

# Attaching Product Policy to the created Product user
resource "aws_iam_policy_attachment" "product_user_product_policy_attachement"{
    for_each = toset(var.product_names)
    name = "${var.system_name}-${each.value}"
    users = [aws_iam_user.product_user[each.value].name]
    roles = [aws_iam_role.product_role[each.value].name]
    policy_arn = aws_iam_policy.product_policy_template[each.value].arn
}

# Attaching Assume Role Policy to the created Product user
resource "aws_iam_policy_attachment" "product_user_assume_role_policy_attachement"{
    for_each = toset(var.product_names)
    name = "${var.system_name}-${each.value}-assume-role"
    users = [aws_iam_user.product_user[each.value].name]
    roles = [aws_iam_role.product_role[each.value].name]
    policy_arn = aws_iam_policy.assume_role_policy_template[each.value].arn
}

# Create Access Key and Secret Key for each user
resource "aws_iam_access_key" "s3_dropbox_key" {
  for_each = toset(var.product_names)
  user = aws_iam_user.product_user[each.value].name
}