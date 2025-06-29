from pyspark.sql.window import Window
from pyspark.sql import functions as f
from pyspark.sql import SparkSession
from pyspark.sql.types import DateType
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from datetime import datetime
import re

def parse_date_string(date_str):
    """
    'Apr 26, 2024'のような文字列をDate型に変換する関数
    
    Args:
        date_str (str): 'MMM dd, yyyy'形式の日付文字列
        
    Returns:
        datetime.date: パースされた日付、パースできない場合はNone
    """
    if not date_str:
        return None
    
    try:
        # 月の略称を数字にマッピング
        month_map = {
            'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
            'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
        }
        
        # 正規表現でパース
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

# UDFとして登録
parse_date_udf = f.udf(parse_date_string, DateType())

def create_dynamic_frame(glue_context, database_name, table_name):
    return glue_context.create_dynamic_frame_from_catalog(
        database=database_name,
        table_name=table_name,
    )
    
glue_context = GlueContext(SparkContext.getOrCreate())

database_name = "stock-catalog-db-stock-csv-glue-123456"
table_name = "stock_data_table"

dynamic_df = create_dynamic_frame(glue_context, database_name, table_name)

df = dynamic_df.toDF()

bucket = 'stock-csv-glue-123456-stock-data'

df_new = df.withColumn(
            "Date", parse_date_udf(f.col("Date"))).withColumn(
                "movingAverage", f.avg(df["adj_close"]).over(
                    Window.partitionBy("code").orderBy("Date").rowsBetween(-5,0)))
                    
df_new.coalesce(1).write.option("header", "true").csv(f"s3://{bucket}/processed", mode='overwrite')