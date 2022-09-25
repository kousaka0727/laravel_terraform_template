resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "${var.pj_name}-${var.env}-alb"

  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
}

resource "aws_lb_listener" "http" {
  port     = 80
  protocol = "HTTP"

  load_balancer_arn = aws_lb.main.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

resource "aws_lb_listener_rule" "main" {
  # ルールを追加するリスナー
  listener_arn = aws_lb_listener.http.arn

  priority = 100

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "http_to_https" {
  listener_arn = aws_lb_listener.http.arn

  priority = 99

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  certificate_arn   = aws_acm_certificate.main.arn

  port     = 443
  protocol = "HTTPS"

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }

  depends_on = [
    aws_acm_certificate_validation.main
  ]
}

resource "aws_lb_listener_rule" "https" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
