resource "aws_ecs_cluster" "main" {
  name = "${var.pj_name}-${var.env}"
}

resource "aws_ecs_service" "main" {
  name = "${var.pj_name}-${var.env}"

  cluster = aws_ecs_cluster.main.name

  launch_type     = "FARGATE"
  desired_count   = "1"
  task_definition = aws_ecs_task_definition.main.arn

  # ECSタスクへ設定するネットワークの設定
  network_configuration {
    # タスクの起動を許可するサブネット
    subnets = [
      for subnet in aws_subnet.privates :
      subnet.id
    ]

    # タスクに紐付けるセキュリティグループ
    security_groups = [aws_security_group.ecs.id]
  }

  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "nginx"
    container_port   = "80"
  }

  depends_on = [
    aws_lb_listener_rule.https
  ]
}

resource "aws_lb_target_group" "main" {
  name = "${var.pj_name}-${var.env}"

  vpc_id = aws_vpc.main.id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/"
  }
}

data "template_file" "container_definitions" {
  template = file("files/task-definitions/app.json")

  vars = {
    tag = "latest"

    # account_id = data.account_id
    # region     = data.aws_region.current.name
    region = "ap-northeast-1"
    name   = "${var.pj_name}-${var.env}"

    db_host     = aws_rds_cluster.main.endpoint
    db_database = var.mysql_db_name
    db_username = var.mysql_user_name

    redis_host = aws_elasticache_cluster.main.cache_nodes.0.address

    db_pass_ssm = "/${var.pj_name}/${var.env}/mysql_password"
    app_key_ssm = "/${var.pj_name}/${var.env}/app_key"
  }
}

resource "aws_ecs_task_definition" "main" {
  family = "${var.pj_name}-${var.env}"

  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  task_role_arn      = aws_iam_role.task_execution.arn
  execution_role_arn = aws_iam_role.task_execution.arn

  container_definitions = data.template_file.container_definitions.rendered
}
