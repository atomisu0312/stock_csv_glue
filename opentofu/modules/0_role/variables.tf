variable "project" {
  description = "The project name"
  type        = string
}

variable "tag_base" {
  description = "The base tag for the project"
  type        = string
}

variable "region" {
  description = "The region in which the IAM role will be created"
  type        = string
} 