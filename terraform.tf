# create S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Public access for S3 bucket

resource "aws_s3_bucket_ownership_controls" "PublicAccess" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "PublicAccess" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Access control list to be public

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.PublicAccess,
    aws_s3_bucket_public_access_block.PublicAccess,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Copying Objects to S3

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key = "index.html"
  source = "/Users/rushikesh/devops-projects/terraform/index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key = "error.html"
  source = "/Users/rushikesh/devops-projects/terraform/error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key = "image.png"
  source = "/Users/rushikesh/devops-projects/terraform/image.png"
  acl = "public-read"
}

# Creating Website

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]
}
