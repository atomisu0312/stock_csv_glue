variable "tag_base" {
  description = "The base tag for the project"
  type        = string
}
variable "project" {
  description = "The project name"
  type        = string
}
variable "s3_bucket_id" {
  description = "The S3 bucket ID"
  type        = string
}
variable "table_name" {
  description = "The name of the table"
  type        = string
}
variable "database_name" {
  description = "The name of the Glue Data Catalog database"
  type        = string
}