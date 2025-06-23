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

# まとめて出力する場合
output "base_resources" {
  description = "Baseから取得した全リソース情報"
  value = {
    s3_bucket_id   = local.s3_bucket_id
    s3_bucket_arn  = local.s3_bucket_arn
    glue_role_arn  = local.glue_role_arn
  }
}