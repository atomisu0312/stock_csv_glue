module "s3" {
  source = "../../../modules/1_s3"
  project = var.project
  tag_base = var.tag_base
  region = var.region
}

module "role" {
  source = "../../../modules/0_role"
  project = var.project
  tag_base = var.tag_base
  region = var.region
}