# baseの状態を参照
data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket = "${var.project}-terraform-state"
    key    = "dev/base/terraform.tfstate"
    region = var.region
  }
}

# baseのアウトプットを参照
locals {
  s3_bucket_id   = data.terraform_remote_state.base.outputs.s3_bucket_id
  s3_bucket_arn  = data.terraform_remote_state.base.outputs.s3_bucket_arn
  glue_role_arn  = data.terraform_remote_state.base.outputs.glue_role_arn
}

# データカタログの作成
module "datacatalog" {
  source = "../../../modules/2_datacatalog"
  project = var.project
  tag_base = var.tag_base
  s3_bucket_id = local.s3_bucket_id
  glue_role_arn = local.glue_role_arn
}

module "athena" {
  source = "../../../modules/3_athena"
  project = var.project
  tag_base = var.tag_base
  s3_bucket_id = local.s3_bucket_id
  database_name = module.datacatalog.database_name
  table_name = module.datacatalog.table_name
}

module "glueetl" {
  source = "../../../modules/4_glueetl"
  project = var.project
  tag_base = var.tag_base
  glue_role_arn = local.glue_role_arn
  database_name = module.datacatalog.database_name
}