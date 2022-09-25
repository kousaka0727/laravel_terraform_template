resource "aws_route_table" "privates" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.pj_name}-${var.env}-private-${each.key}"
  }
}

resource "aws_route" "privates" {
  for_each = var.availability_zones

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.privates[each.key].id
  nat_gateway_id         = aws_nat_gateway.natgws[each.key].id
}

resource "aws_route_table_association" "privates" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.privates[each.key].id
  route_table_id = aws_route_table.privates[each.key].id
}
