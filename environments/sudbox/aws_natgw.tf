resource "aws_eip" "eips" {
  for_each = var.availability_zones

  vpc = true

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.pj_name}-${var.env}-natgw-${each.key}"
  }
}

resource "aws_nat_gateway" "natgws" {
  for_each = var.availability_zones

  subnet_id     = aws_subnet.publics[each.key].id
  allocation_id = aws_eip.eips[each.key].id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.pj_name}-${var.env}-${each.key}"
  }
}
