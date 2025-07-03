#!/usr/bin/python3
from pyspark.sql.functions import udf, col, avg
from pyspark.sql.types import DateType
from pyspark.sql.window import Window
from datetime import datetime
from setup import setup
import re

database_name = "stock-catalog-db-stock-csv-glue-123456"
table_name = "stock_data_table"
bucket = 'stock-csv-glue-123456-stock-data'

def parse_date_string(date_str):
  """
  'Apr 26, 2024'のような文字列をDate型に変換する関数
  """
  if not date_str:
    return None
  
  try:
    month_map = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
        'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    }
    
    pattern = r'^([A-Za-z]{3})\s+(\d{1,2}),\s+(\d{4})$'
    match = re.match(pattern, date_str.strip())
    
    if match:
      month_str, day_str, year_str = match.groups()
      month = month_map.get(month_str)
      day = int(day_str)
      year = int(year_str)
      
      if month and 1 <= day <= 31 and 1900 <= year <= 2100:
          return datetime(year, month, day).date()
    
    return None
      
  except Exception:
      return None

@setup(glue_database_name=database_name, glue_table_name=table_name, target_s3_bucket=bucket)
def process_df(df):
  # UDFとして登録
  parse_date_udf = udf(parse_date_string, DateType())
  
  # 日付を変換して移動平均を計算
  df_new = df.withColumn(
      "date", parse_date_udf(col("date"))
  ).withColumn(
      "moving_average", avg("adj_close").over(
          Window.partitionBy("code").orderBy("date").rowsBetween(-5,0)
      )
  )
  
  print("日付変換と移動平均計算完了")
  return df_new

process_df() # type: ignore
