resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj_name}-${var.env}-private-1a"
  }
}

resource "aws_route" "private_1a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1a.id
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}



resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj_name}-${var.env}-private-1c"
  }
}

resource "aws_route" "private_1c" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1c.id
  nat_gateway_id         = aws_nat_gateway.nat_1c.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}
