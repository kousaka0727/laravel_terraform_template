resource "aws_db_subnet_group" "main" {
  name        = "${var.pj_name}-${var.env}"
  description = "${var.pj_name}-${var.env}"
  subnet_ids  = [
    for subnet in aws_subnet.privates :
    subnet.id
  ]
}

resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.pj_name}-${var.env}"

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot       = true
  final_snapshot_identifier = "ci-aurora-cluster-backup"

  engine = "aurora-mysql"
  port   = "3306"

  database_name   = "poc_db"
  master_username = "poc_user"
  master_password = "poc_pass"
}

resource "aws_rds_cluster_instance" "main" {
  identifier         = "${var.pj_name}-${var.env}"
  cluster_identifier = aws_rds_cluster.main.id

  engine = "aurora-mysql"

  instance_class = "db.t3.small"
}
