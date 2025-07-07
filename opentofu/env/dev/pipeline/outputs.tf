# データカタログモジュールのアウトプット
output "database_name" {
  description = "Glue Data Catalogデータベース名"
  value       = module.datacatalog.database_name
}

output "database_arn" {
  description = "Glue Data CatalogデータベースのARN"
  value       = module.datacatalog.database_arn
}

output "crawler_name" {
  description = "Glueクローラー名"
  value       = module.datacatalog.crawler_name
}

output "crawler_arn" {
  description = "GlueクローラーのARN"
  value       = module.datacatalog.crawler_arn
}

output "table_name" {
  description = "作成されたテーブル名"
  value       = module.datacatalog.table_name
}

output "table_arn" {
  description = "作成されたテーブルのARN"
  value       = module.datacatalog.table_arn
}
