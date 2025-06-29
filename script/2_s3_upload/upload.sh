#!/bin/bash

# S3ファイルアップロードスクリプト
# 使用方法: ./upload.sh [LOCAL_FILE_PATH] [S3_BUCKET] [S3_KEY] [REGION]

set -e

# デフォルト値
DEFAULT_REGION="ap-northeast-1"
DEFAULT_BUCKET="stock-csv-glue-123456-glue-script"
DEFAULT_KEY="script/glue_script.py"

# 引数から値を取得
LOCAL_FILE_PATH=${1:-""}
S3_BUCKET=${2:-$DEFAULT_BUCKET}
S3_KEY=${3:-$DEFAULT_KEY}
REGION=${4:-$DEFAULT_REGION}

echo "=== S3 File Upload Script ==="
echo "Region: $REGION"
echo "Bucket: $S3_BUCKET"
echo "============================="

# 引数チェック
if [ -z "$LOCAL_FILE_PATH" ]; then
    echo "Error: Local file path is required"
    echo "Usage: $0 <local_file_path> [s3_bucket] [s3_key] [region]"
    echo "Example: $0 ./data/TSLA.csv stock-data-bucket raw_files/TSLA.csv"
    exit 1
fi

# ファイルの存在チェック
if [ ! -f "$LOCAL_FILE_PATH" ]; then
    echo "Error: File not found: $LOCAL_FILE_PATH"
    exit 1
fi

# S3キーが指定されていない場合、ファイル名を使用
if [ -z "$S3_KEY" ]; then
    S3_KEY=$(basename "$LOCAL_FILE_PATH")
    echo "Using filename as S3 key: $S3_KEY"
fi

echo "Uploading: $LOCAL_FILE_PATH"
echo "To: s3://$S3_BUCKET/$S3_KEY"

# S3にアップロード
aws s3 cp "$LOCAL_FILE_PATH" "s3://$S3_BUCKET/$S3_KEY" \
    --region "$REGION" \
    --quiet

if [ $? -eq 0 ]; then
    echo "✅ Upload completed successfully!"
    echo "File is now available at: s3://$S3_BUCKET/$S3_KEY"
else
    echo "❌ Upload failed"
    exit 1
fi

# アップロードされたファイルの情報を表示
echo ""
echo "=== Upload Summary ==="
echo "Local file: $LOCAL_FILE_PATH"
echo "S3 location: s3://$S3_BUCKET/$S3_KEY"
echo "File size: $(du -h "$LOCAL_FILE_PATH" | cut -f1)"
