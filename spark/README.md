# PySpark 開発環境サンプル

このプロジェクトは、VS CodeのDev Container機能を利用して、PySparkの実行環境を構築するためのサンプルです。
コンテナ内には、PySpark、Delta Lake、Jupyter Kernelなど、データ分析に必要なライブラリがプリインストールされています。

## ファイル構成

- `test.ipynb`: PySparkの基本的な操作（RDD, DataFrame, SQL）を示すJupyter Notebookサンプルです。
- `.devcontainer/`: Dev Containerの設定ファイルが含まれています。
    - `devcontainer.json`: Dev Containerの構成を定義します。
    - `Dockerfile`: 開発コンテナの環境を構築するための手順を定義します。
- `sampledata/`: サンプルデータが格納されています。
- `README.md`: このファイルです。

## 実行方法 (Dev Container)

### 前提条件

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (VS Code拡張機能)

### 手順

1.  このリポジトリをクローンします。
2.  VS Codeでこの `spark` ディレクトリを直接開きます。
3.  コマンドパレット (`Ctrl+Shift+P` または `Cmd+Shift+P`) を開き、「**Dev Containers: Reopen in Container**」を選択します。
4.  コンテナのビルドが完了するのを待ちます。（初回は時間がかかります）
5.  ビルドが完了すると、VS Codeが自動的にコンテナに接続された状態でリロードされます。
6.  VS Codeのエクスプローラーから `test.ipynb` を開き、セルを順番に実行して動作を確認します。

## 主な機能

- **Dev Containerによる環境構築**: Dockerを使用して、隔離された一貫性のある開発環境を提供します。Java、Python、PySparkなどの依存関係を自動でセットアップします。
- **PySparkサンプルコード**: `test.ipynb` には以下の内容が含まれます。
    - RDD操作（map, collect）
    - DataFrame操作（フィルタリング, グループ化, 集計）
    - SQL操作
    - 基本的な計算処理

## 注意事項

- 初回のコンテナビルドには時間がかかる場合があります。
- このサンプルは、ローカルモードでSparkを実行します。 