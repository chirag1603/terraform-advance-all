## Create all product prefix
resource "aws_s3_bucket_object" "products" {
    for_each = toset(var.product_names)
    bucket = aws_s3_bucket.chirag-data-team-app-dropbox.id
    acl    = "private"
    key    = "product/chirag_${each.value}/"
    source = "/dev/null"
}

## Enable lifecycle rule on product prefix
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_product" {
  bucket = aws_s3_bucket.chirag-data-team-app-dropbox.id
  dynamic "rule"{
    for_each = var.product_names

    content{
        id = "expiration-${rule.value}"
        status = "Enabled"
        /* prefix = "product/chirag_${each.value}" */
        filter {
            prefix = "product/chirag_${rule.value}/"
        }
        expiration {
            days = var.expiration
            }
        }
    }  
}