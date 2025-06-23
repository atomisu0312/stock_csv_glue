# S3モジュールのアウトプット
output "s3_bucket_id" {
  description = "S3バケットのID"
  value       = module.s3.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "S3バケットのARN"
  value       = module.s3.s3_bucket_arn
}

output "s3_bucket_region" {
  description = "S3バケットのリージョン"
  value       = module.s3.s3_bucket_region
}

# ロールモジュールのアウトプット
output "glue_role_arn" {
  description = "GlueロールのARN"
  value       = module.role.glue_role_arn
}

output "glue_role_name" {
  description = "Glueロールの名前"
  value       = module.role.glue_role_name
}

output "glue_role_id" {
  description = "GlueロールのID"
  value       = module.role.glue_role_id
}

# まとめて出力する場合
output "all_resources" {
  description = "全リソースの情報"
  value = {
    s3 = {
      bucket_id   = module.s3.s3_bucket_id
      bucket_arn  = module.s3.s3_bucket_arn
      region      = module.s3.s3_bucket_region
    }
    role = {
      role_arn  = module.role.glue_role_arn
      role_name = module.role.glue_role_name
      role_id   = module.role.glue_role_id
    }
  }
}
