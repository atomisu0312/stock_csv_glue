from pyspark.sql import SparkSession

def convert_column_names(df):
    """カラム名をスネークケースに変換する関数"""
    def to_snake_case(name):
        return name.replace(" ", "_").lower()
    
    for col_name in df.columns:
        snake_case_name = to_snake_case(col_name)
        df = df.withColumnRenamed(col_name, snake_case_name)
    
    print("カラム名変換完了")
    return df


def setup(glue_database_name, glue_table_name, target_s3_bucket):
  """ローカルでは引数を使わないが、Prodでは使うのでその形式に合わせる"""
  def decorator_with_save_data(func):
    def wrapper(*args, **kwargs):
      print("=== 処理開始 ===")

      # SparkSessionの作成
      spark = SparkSession.builder \
          .appName("StockDataProcessing") \
          .getOrCreate()

      print(f"Spark バージョン: {spark.version}")

      # データフレームの読み込み
      df = spark.read.csv("./sampledata/input.csv", header=True, inferSchema=True)
      print(f"データ読み込み完了: {df.count()}行")

      df = convert_column_names(df)

      # データフレームの変換
      result_df = func(df, *args, **kwargs)

      output_path = "./sampledata/output"
      result_df.coalesce(1).write.mode("overwrite").option("header", "true").csv(output_path)
      print(f"結果保存完了: {output_path}")

      spark.stop()
      return result_df
    return wrapper
  return decorator_with_save_data