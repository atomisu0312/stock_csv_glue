# Glue Crawler
resource "aws_glue_job" "stock_data_job" {
  name          = "${var.project}-stock-data-job"
  role_arn      = var.glue_role_arn

  command {
    name = "glueetl"
    script_location = "s3://${var.project}-glue-script/script/glue_script.py"
  }

  default_arguments = {
    "--job-language" = "python"
    "--job-type" = "glueetl"
  }

  glue_version = "4.0"
  max_capacity = 2.0
  max_retries = 0
  timeout = 2880
  execution_class = "STANDARD"

  tags = {
    Project = var.tag_base
  }
}
