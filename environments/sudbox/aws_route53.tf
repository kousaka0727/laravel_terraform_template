data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "validation" {
  for_each = {
    for i in aws_acm_certificate.main.domain_validation_options : i.domain_name => {
      name   = i.resource_record_name
      type   = i.resource_record_type
      record = i.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]

  zone_id = data.aws_route53_zone.main.id
  ttl     = 60


  depends_on = [
    aws_acm_certificate.main
  ]
}


resource "aws_route53_record" "main" {
  type = "A"

  name    = var.domain
  zone_id = data.aws_route53_zone.main.id

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
