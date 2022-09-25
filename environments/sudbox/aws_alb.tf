resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "${var.pj_name}-${var.env}-alb"

  security_groups = [aws_security_group.alb.id]
  subnets = [
    for subnet in aws_subnet.publics :
    subnet.id
  ]
}

resource "aws_lb_listener" "http" {
  port     = 80
  protocol = "HTTP"

  load_balancer_arn = aws_lb.main.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "<html><head><title>404 Not Found</title></head><body><h1>Not Found</h1><hr><address>Apache/2.2.31</address></body></html>"
    }
  }
}

resource "aws_lb_listener_rule" "http_to_https" {
  listener_arn = aws_lb_listener.http.arn

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
