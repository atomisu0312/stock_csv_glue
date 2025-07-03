from awsglue.context import GlueContext
from pyspark.context import SparkContext


def setup(glue_database_name, glue_table_name, target_s3_bucket):
    """AWS Glue環境用のデコレーター"""
    def decorator_with_save_data(func):
        def wrapper(*args, **kwargs):
            print("=== AWS Glue処理開始 ===")

            # GlueContextの作成
            glue_context = GlueContext(SparkContext.getOrCreate())
            print(f"GlueContext作成完了")

            # DynamicFrameの作成
            dynamic_df = glue_context.create_dynamic_frame_from_catalog(
                database=glue_database_name,
                table_name=glue_table_name,
            )
            df = dynamic_df.toDF()
            print(f"データ読み込み完了: {df.count()}行")

            # データフレームの変換
            result_df = func(df, *args, **kwargs)

            # S3に保存
            output_path = f"s3://{target_s3_bucket}/processed"
            result_df.coalesce(1).write.mode("overwrite").option("header", "true").csv(output_path, mode='overwrite')
            print(f"結果保存完了: {output_path}")

            return result_df
        return wrapper
    return decorator_with_save_data 