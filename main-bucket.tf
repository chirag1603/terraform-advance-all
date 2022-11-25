## Create dropbox bucket
resource "aws_s3_bucket" "chirag-data-team-app-dropbox" {
  bucket = var.system_name
  tags = {
    Name        = var.system_name
    Environment = var.environment_name
  }
}

## Making the bucket private
resource "aws_s3_bucket_acl" "private_acl"{
    bucket = aws_s3_bucket.chirag-data-team-app-dropbox.id
    acl = "private"
}

## Dynamic Policy to grant product role access to the bucket
data "aws_iam_policy_document" "product_role_access_policy"{
  /* source_policy_documents = [data.aws_iam_policy_document.allow_chirag_vpn_ips.json] */
  dynamic statement {
    for_each = toset(var.product_names)
    content{
    sid = "readonlypolicychirag${statement.value}"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:role/${var.system_name}-${statement.value}"]
    }
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.system_name}",
      "arn:aws:s3:::${var.system_name}/*"
    ]
  }
  }

}

## Policy to Restrict bucket access through chirag VPN only and merging it with the combined product_role_access_policy policy
data "aws_iam_policy_document" "allow_chirag_vpn_ips" {
  source_policy_documents = [data.aws_iam_policy_document.product_role_access_policy.json]
  statement {
    sid = "SourceIP"
    effect = "Deny"

    principals {
      type = "*"
      identifiers = ["*"] 
    }
    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${var.system_name}",
      "arn:aws:s3:::${var.system_name}/*"
    ]

    condition {
      test = "NotIpAddress"
      variable = "aws:SourceIp"
      values = ["0.0.0.0/32"]

    }
  }
} 


## Attaching Aggregated allow_chirag_vpn_ips Policy
resource "aws_s3_bucket_policy" "allow_chirag_vpn_ips"{
  bucket = aws_s3_bucket.chirag-data-team-app-dropbox.id
  policy = data.aws_iam_policy_document.allow_chirag_vpn_ips.json
  depends_on = [
      aws_iam_role.product_role
  ]
} 