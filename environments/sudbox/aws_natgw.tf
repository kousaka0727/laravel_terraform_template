resource "aws_eip" "nat_1a" {
  vpc = true

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.pj_name}-${var.env}-natgw-1a"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = aws_subnet.public_1a.id
  allocation_id = aws_eip.nat_1a.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.pj_name}-${var.env}-1a"
  }
}


resource "aws_eip" "nat_1c" {
  vpc = true

  tags = {
    Name = "${var.pj_name}-${var.env}-natgw-1c"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  subnet_id     = aws_subnet.public_1c.id
  allocation_id = aws_eip.nat_1c.id

  tags = {
    Name = "${var.pj_name}-${var.env}-1c"
  }
}
