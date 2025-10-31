resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "public-${count.index}" }
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnets[count.index]
  tags = { Name = "private-${count.index}" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}
resource "aws_eip" "nat" {
  tags = {
    Name = "nat-eip"
  }
}


