resource "aws_ssm_parameter" "mysql_password" {
  name        = "/${var.pj_name}/${var.env}/mysql_password"
  value       = var.mysql_password
  description = "Password to connect to mysql"

  type   = "SecureString"
  key_id = aws_kms_key.application.key_id

  tags = {
    Group      = var.pj_name
    Enviroment = var.env
  }
}

resource "aws_ssm_parameter" "app_key" {
  name        = "/${var.pj_name}/${var.env}/app_key"
  value       = var.mysql_password
  description = "Appkey used in laravel"

  type   = "SecureString"
  key_id = aws_kms_key.application.key_id

  tags = {
    Group      = var.pj_name
    Enviroment = var.env
  }
}
