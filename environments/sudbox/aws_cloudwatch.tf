resource "aws_cloudwatch_log_group" "nginx" {
  name              = "${var.pj_name}-${var.env}/nginx"
  retention_in_days = "7"
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.pj_name}-${var.env}/app"
  retention_in_days = "7"
}
