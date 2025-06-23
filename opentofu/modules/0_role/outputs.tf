output "glue_role_arn" {
  description = "The ARN of the Glue IAM role"
  value       = aws_iam_role.glue_role.arn
}

output "glue_role_name" {
  description = "The name of the Glue IAM role"
  value       = aws_iam_role.glue_role.name
}

output "glue_role_id" {
  description = "The ID of the Glue IAM role"
  value       = aws_iam_role.glue_role.id
} 