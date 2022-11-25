# Create policy from template for product prefix access only allowing list and upload, dowload and delete not allowed
resource "aws_iam_policy" "product_policy_template" {
    for_each = toset(var.product_names)
    name = "${var.system_name}-${each.value}"
    policy = templatefile("${path.module}/product_policy_json.tftpl", {product = each.value, system_name = var.system_name})
}

# Create policy from template for product assume role
resource "aws_iam_policy" "assume_role_policy_template" {
    for_each = toset(var.product_names)
    name = "${var.system_name}-${each.value}-assume-role"
    policy = templatefile("${path.module}/product_assume_role_policy_json.tftpl", {product = each.value, account_id = var.account_id, system_name = var.system_name})
}

# Create roles for the products
resource "aws_iam_role" "product_role" {
    for_each = toset(var.product_names)
    name = "${var.system_name}-${each.value}"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    "createdby" = "terraform"
  }
}

# Attach product folder access policy to respective roles
resource "aws_iam_role_policy_attachment" "product_role_attachement" {
    for_each = toset(var.product_names)
    role = aws_iam_role.product_role[each.value].name
    policy_arn = aws_iam_policy.product_policy_template[each.value].arn
}

# Attach assume role policy for the respective product
resource "aws_iam_role_policy_attachment" "assume_s3_dropbox_role" {
    for_each = toset(var.product_names)
    role = aws_iam_role.product_role[each.value].name
    policy_arn = aws_iam_policy.assume_role_policy_template[each.value].arn  
}