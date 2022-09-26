resource "aws_subnet" "publics" {
  for_each = var.availability_zones

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, each.value)
  availability_zone = each.key

  tags = {
    Name = "${var.pj_name}-${var.env}-public-${each.key}"
  }
}

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
