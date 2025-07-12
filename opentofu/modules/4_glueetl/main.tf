resource "aws_s3_object" "glue_etl_script" {
  bucket = "${var.project}-glue-script" # TODO バケット名をmain.tfで定義しておいた方がクリーン 
  key    = "script/process.py" # TODO ファイル名も同様にmain側で定義しておく
  source = "../../../../spark/process.py" # main.tfのディレクトリからの相対パスである点に注意
}

resource "aws_s3_object" "glue_etl_script_setup" {
  bucket = "${var.project}-glue-script" # 上のTODOと同じ
  key    = "script/setup.py" # TODO ファイル名はmain側で定義しておく
  source = "../../../../spark/prod/setup.py" # main.tfのディレクトリからの相対パスである点に注意
}

# Glue Crawler
resource "aws_glue_job" "stock_data_job" {
  name          = "${var.project}-stock-data-job" # TODO リソース名はmainで定義してもいいかも
  role_arn      = var.glue_role_arn

  command {
    name = "glueetl"
    script_location = "s3://${var.project}-glue-script/${aws_s3_object.glue_etl_script.key}"
  }

  default_arguments = {
    "--job-language" = "python"
    "--job-type" = "glueetl"
    "--extra-py-files" = "s3://${var.project}-glue-script/${aws_s3_object.glue_etl_script_setup.key}"
  }

  glue_version = "4.0" # TODO パラメータの定義もmainに統合してもいいかもしんね
  max_capacity = 2.0
  max_retries = 0
  timeout = 2880
  execution_class = "STANDARD"

  tags = {
    Project = var.tag_base
  }
}
