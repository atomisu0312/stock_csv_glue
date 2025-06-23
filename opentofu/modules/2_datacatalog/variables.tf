variable "project" {
  description = "The project name"
  type        = string
}

variable "tag_base" {
  description = "The base tag for the project"
  type        = string
}

variable "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  type        = string
}

variable "glue_role_arn" {
  description = "The ARN of the Glue role"
  type        = string
}