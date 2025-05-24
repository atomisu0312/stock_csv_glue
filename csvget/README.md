# 株価データ取得・分析ツール

このプロジェクトは、Yahoo Financeから株価データを取得し、分析するためのツールです。

## 機能

- Yahoo Financeから株価データを取得
- 日付形式のバリデーション（YYYY-MM-DD形式）
- 欠損値（休日データ）の補完
- CSVファイル形式でのデータ出力

## 必要条件

- Python 3.10以上
- 必要なパッケージ:
  - beautifulsoup4 >= 4.13.4
  - ipykernel >= 6.29.5
  - lxml >= 5.4.0
  - requests >= 2.32.3

## インストール方法

```bash
# プロジェクトのインストール
uv sync
```

## 使用方法

### 株価データの取得

```python
from obtain_csv import get_stock_data

# データ取得
code = "4755.T"  # 証券コード
from_date = "2024-04-30"  # 開始日（YYYY-MM-DD形式）
to_date = "2025-04-30"    # 終了日（YYYY-MM-DD形式）

get_stock_data(code, from_date, to_date)
```

## 出力ファイル形式

CSVファイルには以下の列が含まれます：
- Date: 日付
- Open: 始値
- High: 高値
- Low: 安値
- Close: 終値
- Adj Close: 調整後終値
- Volume: 出来高

## 注意事項

- 日付は必ずYYYY-MM-DD形式で指定してください
- Yahoo Financeの利用制限に注意してください
- 取得したデータは投資判断の参考情報としてのみ使用してください

## ライセンス

MIT License
