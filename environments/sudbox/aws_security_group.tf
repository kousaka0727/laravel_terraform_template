resource "aws_security_group" "alb" {
  name        = "${var.pj_name}-${var.env}-alb"
  description = "${var.pj_name} ${var.env} alb"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.pj_name}-${var.env}-alb"
  }
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

#  ==================================================== ECS ====================================================

resource "aws_security_group" "ecs" {
  name        = "${var.pj_name}-${var.env}-ecs"
  description = "${var.pj_name} ${var.env} ecs"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.pj_name}-${var.env}-ecs"
  }
}

# resource "aws_security_group_rule" "ecs" {
#   security_group_id = aws_security_group.ecs.id

#   type = "ingress"

#   from_port = 80
#   to_port   = 80
#   protocol  = "tcp"

#   # 同一VPC内からのアクセスのみ許可
# cidr_blocks = ["10.0.0.0/16"]
# }


#  ==================================================== RDS ====================================================
resource "aws_security_group" "rds" {
  name        = "${var.pj_name}-${var.env}-rds"
  description = "${var.pj_name} ${var.env} rds"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.pj_name}-${var.env}-rds"
  }
}
