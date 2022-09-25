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
    subnets = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
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
    db_username = "poc_user"
    db_password = "poc_pass"
    db_database = "poc_db"

    app_key = "base64:hE9iPSnk+ytfZKAXhn/vVhj0+Vo1aPIduk7yghHCwEI="
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
