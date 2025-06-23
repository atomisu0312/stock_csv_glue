# S3バケットの作成
resource "aws_s3_bucket" "stock_data" {
  bucket = "${var.project}-stock-data"
  tags = {
    Project = var.tag_base
  }
}

# バージョニングの有効化
resource "aws_s3_bucket_versioning" "stock_data_versioning" {
  bucket = aws_s3_bucket.stock_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# サーバーサイド暗号化の設定
resource "aws_s3_bucket_server_side_encryption_configuration" "stock_data_encryption" {
  bucket = aws_s3_bucket.stock_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# パブリックアクセスブロックの設定
resource "aws_s3_bucket_public_access_block" "stock_data_public_access_block" {
  bucket = aws_s3_bucket.stock_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 