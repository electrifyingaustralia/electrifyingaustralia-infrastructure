resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket
  tags = {
    Name        = "electrifying-australia"
    Environment = "production"
    Project     = "electrifying-australia"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.s3_bucket}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  # Rule 1: Database backups — move to Glacier after 31 days, never delete
  rule {
    id     = "database-backups-lifecycle"
    status = "Enabled"

    filter {
      prefix = "database-backups/"
    }

    transition {
      days          = 31
      storage_class = "GLACIER_IR"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Rule 2: Media — keep forever
  rule {
    id     = "media-keep-forever"
    status = "Enabled"

    filter {
      prefix = "media/"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
