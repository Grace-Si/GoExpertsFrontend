resource "aws_s3_bucket" "frontend-bucket" {
    bucket = var.fe_bucket
    tags = {
        "Project" = "GoExperts"
        "ManagedBy" = "Terraform"
    }
    force_destroy = true # when re-provision 
}

# create s3 bucket for logging
resource "aws_s3_bucket" "log_bucket" {
    bucket = "${var.fe_bucket}-logs"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
    bucket = aws_s3_bucket.log_bucket.id
    acl = "private"
    depends_on = [aws_s3_bucket_ownership_controls.log_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_acl_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.public_block]
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket_lifecycle" {
    bucket = aws_s3_bucket.log_bucket.id
    rule {
        id = "logExpiration"
        status = "Enabled"

        expiration {
          days = 30
        }
    }
}
# s3 bucket log setting
resource "aws_s3_bucket_logging" "log" {
    bucket = aws_s3_bucket.frontend-bucket.id
    
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "goexperts-s3-log/"
}

# to enable Static website hosting, because I am using OAI, so no need to enable Static website hosting 
# resource "aws_s3_bucket_website_configuration" "frontend-bucket-website-config" {
#   bucket = aws_s3_bucket.frontend-bucket.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }

resource "aws_s3_bucket_acl" "frontend-bucket-acl" {
  bucket     = aws_s3_bucket.frontend-bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.frontend-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.public_block]
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.frontend-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# add bucket policy to allow the Cloudfront OAI get objects:
resource "aws_s3_bucket_policy" "frontend-bucket-policy" {
  bucket = aws_s3_bucket.frontend-bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}

# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.frontend-bucket.arn,
      "${aws_s3_bucket.frontend-bucket.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [var.oai_arn]
    }
  }
}
  