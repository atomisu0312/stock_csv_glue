output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.stock_data.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.stock_data.arn
}

output "s3_bucket_region" {
  description = "The region of the S3 bucket"
  value       = aws_s3_bucket.stock_data.region
} 