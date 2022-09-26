resource "aws_elasticache_cluster" "main" {
  cluster_id = "${var.pj_name}-${var.env}-redis"
  engine               = "redis"
  engine_version       = "6.2"
  node_type            = "cache.t3.micro"
  port                 = 6379
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.main.id
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis.id]

  lifecycle {
    ignore_changes = [engine_version]
  }
}

resource "aws_elasticache_parameter_group" "main" {
  name        = "${var.pj_name}-${var.env}-redis-cache-params"
  family      = "redis6.x"
  description = "Cache cluster default param group"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "notify-keyspace-events"
    value = "KEx"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name        = "${var.pj_name}-${var.env}"
  description = "${var.env} CacheSubnetGroup"
  subnet_ids = [
    for subnet in aws_subnet.privates :
    subnet.id
  ]
}
