resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj_name}-${var.env}"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "publics" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.publics[each.key].id
  route_table_id = aws_route_table.public.id
}
