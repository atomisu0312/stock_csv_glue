/**
別でS3バケットを立てる場合には使う感じかな？
resource "aws_s3_bucket" "stock_data" {
  bucket = "stock-data-athena-${var.project}"
}

resource "aws_athena_database" "stock_data" {
  name   = "stock_data"
  bucket = var.s3_bucket_id
}
**/
resource "aws_athena_workgroup" "stock_data" {
  name = "stock-data-workgroup-${var.project}"
  
  configuration {
    result_configuration {
      output_location = "s3://${var.s3_bucket_id}/athena_results/"
    }
  }
  
  tags = {
    Project = var.tag_base
  }
}

resource "aws_athena_named_query" "stock_data_query" {
  name      = "stock-data-query-${var.project}"
  workgroup = aws_athena_workgroup.stock_data.name
  database  = var.database_name
  query     = "SELECT * FROM \"${var.database_name}\".\"${var.table_name}\" LIMIT 100;"
}