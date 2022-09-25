resource "aws_subnet" "publics" {
  for_each = var.availability_zones

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, each.value)
  availability_zone = each.key

  tags = {
    Name = "${var.pj_name}-${var.env}-public-${each.key}"
  }
}

resource "aws_subnet" "privates" {
  for_each = var.availability_zones

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, each.value + 3)
  availability_zone = each.key

  tags = {
    Name = "${var.pj_name}-${var.env}-private-${each.key}"
  }
}
