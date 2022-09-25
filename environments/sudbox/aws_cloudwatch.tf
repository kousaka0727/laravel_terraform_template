resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.pj_name}-${var.env}/ecs"
  retention_in_days = "7"
}
