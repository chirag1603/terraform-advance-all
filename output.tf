# Printing the access key
/* output "secret_key" {
  value = aws_iam_access_key.s3_dropbox_key
  sensitive = true
}
output "access_key" {
  value = aws_iam_access_key.s3_dropbox_key[*]
  sensitive = true
  
} */



# Print the role names
output "product_role_arns"{
    value = [
        for product in aws_iam_role.product_role : product.arn
    ]
}

# Print Product Policy ARNs
output "product_policy_arns"{
    value = [
        for policy in aws_iam_policy.product_policy_template : policy.arn
    ]
}

# Print Assume Role Plociy ARNs
output "assume_role_policy_arns"{
    value = [
        for policy in aws_iam_policy.assume_role_policy_template : policy.arn
    ]
}

# Print Product users names
output "product_user"{
    value = [
        for user in aws_iam_user.product_user : user.name
    ]
}

# Print Product paths names
output "product_path" {
    value = [
        for path in aws_s3_bucket_object.products : path.id
    ]
  
}

/* output "policy_document"{
    value = data.aws_iam_policy_document.product_role_access_policy
} */
