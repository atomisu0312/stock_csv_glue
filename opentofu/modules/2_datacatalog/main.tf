resource "aws_glue_catalog_database" "glue_catalog_database" {
  name = "stock-catalog-db-${var.project}"
  tags = {
    Project = var.tag_base
  }
}

# 手動でテーブルを作成（クローラーより先に作成）
resource "aws_glue_catalog_table" "stock_data" {
  name          = "stock_data_table"
  database_name = aws_glue_catalog_database.glue_catalog_database.name
  table_type    = "EXTERNAL_TABLE"
  
  storage_descriptor {
    location      = "s3://${var.s3_bucket_id}/raw_files/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat" # TODO リサーチしておくこと
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info {
      name                  = "csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde" # TODO リサーチしておくこと
      
      parameters = {
        "separatorChar" = ","
        "quoteChar"     = "\""
        "skip.header.line.count" = "1"  # ヘッダー行をスキップ
      }
    }
    
    # 株価データのカラム定義
    columns {
      name = "code"
      type = "string"
    }
    columns {
      name = "date"
      type = "string"
    }
    
    columns {
      name = "open"
      type = "string"
    }
    
    columns {
      name = "high"
      type = "string"
    }
    
    columns {
      name = "low"
      type = "string"
    }
    
    columns {
      name = "close"
      type = "string"
    }
    
    columns {
      name = "adj_close"
      type = "string"
    }
    
    columns {
      name = "volume"
      type = "string"
    }
  }
  
  # テーブルパラメータ
  parameters = {
    "classification" = "csv"
    "skip.header.line.count" = "1"
  }
  
}

# Glue Crawler（既存テーブルを更新する設定）
resource "aws_glue_crawler" "stock_crawler" {
  name          = "StockCrawler-${var.project}"
  database_name = aws_glue_catalog_database.glue_catalog_database.name
  role          = var.glue_role_arn
  
  # S3ターゲット設定
  s3_target {
    path = "s3://${var.s3_bucket_id}/raw_files/" # TODO S3ターゲットもmainで定義しておくといいかも
  }
  
  # スキーマ変更ポリシー（既存テーブルを更新）
  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"  # 既存テーブルを更新 TODO あったらダメじゃねこれ？
  }
  
  # 再クロールポリシー
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING" # 固定でOK（とりあえず）
  }
  
  # リネージ設定
  lineage_configuration {
    crawler_lineage_settings = "DISABLE"
  }
  
  tags = {
    Project = var.tag_base
  }
  
  # テーブル作成後にクローラーを実行
  depends_on = [aws_glue_catalog_table.stock_data]
}