#!/bin/bash
# Usage: ./run_s3_upload.sh [CSV_PATH] [BUCKET_NAME] [REGION] [S3_PREFIX]
#
# Description:
#   Uploads a CSV file to a specified prefix (folder) in an S3 bucket.
#
# Arguments:
#   CSV_PATH      : The path to the CSV file to upload. (Required)
#   BUCKET_NAME   : The name of the S3 bucket. (Default: "stock-csv-glue-123456-stock-data")
#   REGION        : The AWS region. (Default: "ap-northeast-1")
#   S3_PREFIX     : The destination prefix (folder) in S3. (Default: "raw_data/")

set -eu

# 1. デフォルト値の設定
DEFAULT_BUCKET_NAME="stock-csv-glue-123456-stock-data"
DEFAULT_REGION="ap-northeast-1"
DEFAULT_S3_PREFIX="raw_data/"

# 引数から値を取得
CSV_PATH=${1:?"Error: CSV_PATH is a required argument."}
BUCKET_NAME=${2:-$DEFAULT_BUCKET_NAME}
REGION=${3:-$DEFAULT_REGION}
S3_PREFIX=${4:-$DEFAULT_S3_PREFIX}
S3_URI="s3://${BUCKET_NAME}/${S3_PREFIX}"

# 2. S3アップロードを実行
echo "🔄 Starting script..."
echo "  - CSV Path: ${CSV_PATH}"
echo "  - Target S3 URI: ${S3_URI}"

echo "🚀 Uploading file to S3..."
if aws s3 cp "${CSV_PATH}" "${S3_URI}" --region "${REGION}"; then
  FILE_NAME=$(basename "${CSV_PATH}")
  FINAL_PATH="${S3_URI}${FILE_NAME}"
  echo "✅ Successfully uploaded ${CSV_PATH} to ${FINAL_PATH}"
else
  echo "❌ Failed to upload ${CSV_PATH}."
  exit 1
fi

echo "🎉 Script finished."