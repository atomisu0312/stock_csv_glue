# AWS上の株価データ分析基盤

このプロジェクトは、AWSの各種サービスを利用して株価データの収集、処理、分析を行うための包括的なデータ基盤を提供します。データ取得から分析までのワークフロー全体を自動化し、Infrastructure as Code (IaC) を活用することで、デプロイと管理を容易にします。

## アーキテクチャ

このプラットフォームは、以下のAWSサービスを使用したサーバーレスアーキテクチャで構築されています。

-   **データ取得**: Pythonスクリプト（`BeautifulSoup`, `Selenium`, `Requests`）を使用してWebから株価データをスクレイピングし、CSVファイルとして保存します。
-   **データレイク**: Amazon S3 を中央データレイクとして使用し、生のCSVデータと処理済みデータを保存します。
-   **ETL (Extract, Transform, Load)**: AWS Glue を使用して生データをクロールし、データカタログを作成し、PySpark��ースのETLジョブを実行してデータを変換・クレンジングします。
-   **データ分析**: Amazon Athena を使用して、S3に保存されている処理済みデータに対してインタラクティブなSQLクエリを実行します。
-   **Infrastructure as Code (IaC)**: OpenTofu（Terraformのフォーク）を使用して、必要なすべてのAWSリソースを定義・管理します。

## ディレクトリ構成

```
.
├── AWS-Glue.ipynb                # AWS Glueの開発・テスト用Jupyter Notebook
├── csvget/                       # 株価データスクレイピング用Pythonプロジェクト
│   ├── pyproject.toml            # プロジェクトのメタデータと依存関係
│   ├── README.md                 # csvgetモジュール用のREADME
│   └── ...
├── data/                         # データ保存用ディレクトリ（ダウンロードしたCSVなど）
├── opentofu/                     # AWSインフラ管理用OpenTofuプロジェクト
│   ├── env/dev/base/main.tf      # 開発環境用のメインOpenTofu設定ファイル
│   ���── ...
└── script/                       # 自動化用シェルスクリプト
    └── 1_athena_execute/
        └── run_athena_query.sh   # Athenaクエリ実行用スクリプト
```

## セットアップとデプロイ

### 前提条件

-   [Python 3.10+](https://www.python.org/)
-   Python依存関係管理ツール [Rye](https://rye-up.com/)
-   [OpenTofu](https://opentofu.org/) (または Terraform)
-   AWS認証情報が設定済みの [AWS CLI](https://aws.amazon.com/cli/)

### 1. Python環境のセットアップ

`csvget`ディレクトリに移動し、必要なPythonパッケージをインストールします。

```bash
cd csvget
rye sync
```

### 2. インフラのデプロイ

OpenTofuの設定ディレクトリに移動し、AWSリソースをデプロイします。

```bash
cd opentofu/env/dev/base
tofu init
tofu apply
```

これにより、必要なS3バケット、IAMロール、Glueクローラー、Glueジョブが作成されます。

## 使い方

### 1. データ取得

`csvget`ディレクトリ内のPythonスクリプトを実行して、株価データをダウンロードします。具体的なスクリプトとその使用方法は`csvget/README.md`を参照してください。

### 2. データ処理 (ETL)

生のデータが指定のS3バケットにアップロードされたら、AWSマネジメントコンソールまたはAWS CLIを使用してAWS GlueクローラーとETLジョブを実行できます。`AWS-Glue.ipynb`ノートブックには、これらのタスクを実行するためのステップバイステップガイドが含まれています。

### 3. データ分析

ETLジョブがデータの処理を正常に完了したら、Amazon Athenaを使用してデータを分析できます。`script/1_athena_execute/run_athena_query.sh`スクリプトを使用すると、事前に定義されたクエリを簡単に実行できます。

```bash
cd script/1_athena_execute
./run_athena_query.sh [WORKGROUP_NAME] [REGION] [BUCKET_NAME] [QUERY_INDEX]
```

デフォルト値や詳細については、スクリプトを参照してください。