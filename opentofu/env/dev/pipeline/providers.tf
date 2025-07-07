provider "aws" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  region = var.region
  default_tags {
    tags = {
      Project = var.tag_base
    }
  }
}