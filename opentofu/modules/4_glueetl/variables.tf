variable "tag_base" {
  description = "The base tag for the project"
  type        = string
}
variable "project" {
  description = "The project name"
  type        = string
}

variable "glue_role_arn" {
  description = "The ARN of the Glue role"
  type        = string
}

variable "database_name" {
  description = "The name of the Glue database"
  type        = string
}