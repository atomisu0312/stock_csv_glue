output "database_name" {
  description = "The name of the Glue catalog database"
  value       = aws_glue_catalog_database.glue_catalog_database.name
}

output "database_arn" {
  description = "The ARN of the Glue catalog database"
  value       = aws_glue_catalog_database.glue_catalog_database.arn
}

output "crawler_name" {
  description = "The name of the Glue crawler"
  value       = aws_glue_crawler.stock_crawler.name
}

output "crawler_arn" {
  description = "The ARN of the Glue crawler"
  value       = aws_glue_crawler.stock_crawler.arn
}

output "table_name" {
  description = "The name of the created table"
  value       = aws_glue_catalog_table.stock_data.name
}

output "table_arn" {
  description = "The ARN of the created table"
  value       = aws_glue_catalog_table.stock_data.arn
}
