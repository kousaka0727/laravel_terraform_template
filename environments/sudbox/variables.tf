#====================================
# 全般
#====================================

variable "pj_name" {
  default = "nomura-id-tougou" //TODO: hogeに変更
}

variable "region" {
  default = "ap-northeast-1"
}

variable "env" {
  default = "sandbox"
}

variable "availability_zones" {
  type = map(number)

  default = {
    ap-northeast-1a = 1
    ap-northeast-1c = 2
  }
}

variable "domain" {
  default = "jktou.com" //TODO: hogeに変更
}

variable "coomon_remote_state" {
  default = "common.terraform.tfstate"
}

#====================================
# DB関連
#====================================

variable "mysql_user_name" {
  default = "hogehoge"
}

variable "mysql_db_name" {
  default = "hogehoge"
}

variable "mysql_password" {
  type = string
    sensitive = true
}

#====================================
# app関連
#====================================

variable "app_key" {
  sensitive = true
  default = "base64:g6b4eEmIlbuNMWgx8p4PlMGQNP/eRKO5uh9KV7WUj18=" //TODO： 後で消す
}

#====================================
# ECS関連
#====================================

variable "ecr_region" {
  default = "ap-northeast-1"
}

variable "nginx_docker_dir" {
  default = "./files/dockers/nginx"
}
variable "nginx_image_name" {
  default = "nginx_base_image"
}
variable "php_docker_dir" {
  default = "./files/dockers/php"
}

variable "php_image_name" {
  default = "php_base_image"
}
