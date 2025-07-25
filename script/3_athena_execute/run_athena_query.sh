#!/bin/bash

# Athenaクエリ実行スクリプト
# 使用方法: ./run_athena_query.sh [WORKGROUP_NAME] [REGION] [BUCKET_NAME] [QUERY_INDEX]

set -eu

# 1. デフォルト値の設定
DEFAULT_REGION="ap-northeast-1"
DEFAULT_BUCKET="stock-csv-glue-123456-stock-data"
DEFAULT_WORKGROUP="stock-data-workgroup-stock-csv-glue-123456"
DEFAULT_QUERY_INDEX=0

# 引数から値を取得
WORKGROUP_NAME=${1:-$DEFAULT_WORKGROUP}
REGION=${2:-$DEFAULT_REGION}
BUCKET_NAME=${3:-$DEFAULT_BUCKET}
QUERY_INDEX=${4:-$DEFAULT_QUERY_INDEX}

echo "=== Athena Query Execution Script ==="
echo "Region: $REGION"
echo "Output Bucket: $BUCKET_NAME"
echo "====================================="

# 2. クエリを実行
# 2.1. 利用可能なNamed Queriesを取得
echo "Getting available named queries..."
NAMED_QUERIES=$(aws athena list-named-queries --region $REGION --work-group $WORKGROUP_NAME --query 'NamedQueryIds' --output text)

if [ -z "$NAMED_QUERIES" ] || [ "$NAMED_QUERIES" = "None" ]; then
    echo "Error: No named queries found"
    exit 1
fi

# 2.2. Named Queryの詳細を取得
echo "Getting named query details..."
QUERY_ID=$(aws athena list-named-queries --work-group $WORKGROUP_NAME --query "NamedQueryIds[$QUERY_INDEX]" --output text)

echo "Found Query ID: $QUERY_ID"

# 2.3. Named Queryのクエリ文字列を取得
echo "Getting query string..."
QUERY_STRING=$(aws athena get-named-query \
    --named-query-id $QUERY_ID \
    --region $REGION \
    --query 'NamedQuery.QueryString' \
    --output text)

echo "Query String: $QUERY_STRING"

# 2.4. クエリを実行
echo "Executing query..."
QUERY_EXECUTION_ID=$(aws athena start-query-execution \
    --query-string "$QUERY_STRING" \
    --work-group $WORKGROUP_NAME \
    --region $REGION \
    --query 'QueryExecutionId' \
    --output text)

echo "Query Execution ID: $QUERY_EXECUTION_ID"

# 3. クエリの完了を待機
echo "Waiting for query completion..."
while true; do
    STATUS=$(aws athena get-query-execution \
        --query-execution-id $QUERY_EXECUTION_ID \
        --region $REGION \
        --query 'QueryExecution.Status.State' \
        --output text)
    
    echo "Query Status: $STATUS"
    
    case $STATUS in
        "SUCCEEDED")
            echo "✅ Query completed successfully!"
            break
            ;;
        "FAILED")
            ERROR_MSG=$(aws athena get-query-execution \
                --query-execution-id $QUERY_EXECUTION_ID \
                --region $REGION \
                --query 'QueryExecution.Status.StateChangeReason' \
                --output text)
            echo "❌ Query failed: $ERROR_MSG"
            exit 1
            ;;
        "CANCELLED")
            echo "❌ Query was cancelled"
            exit 1
            ;;
        *)
            echo "⏳ Query is still running... waiting 5 seconds"
            sleep 5
            ;;
    esac
done

# 4. 結果を取得・保存
# 4.1. 結果を取得
echo "Getting query results..."
aws athena get-query-results \
    --query-execution-id $QUERY_EXECUTION_ID \
    --region $REGION > ./result.json

# 4.2. 結果ファイルの場所を表示
echo ""
echo "=== Query Results ==="
echo "Results are saved to: s3://$BUCKET_NAME/athena_results/"
echo "Query Execution ID: $QUERY_EXECUTION_ID"
echo "You can also view results in the Athena console" 