resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in var.azs : idx => az }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value
  cidr_block              = var.public_subnet_cidrs[each.key]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-${each.value}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, az in var.azs : idx => az }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = var.private_subnet_cidrs[each.key]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-${each.value}"
    Tier = "private"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rt-public"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT（シンプルに1台構成：コスト優先）
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-natgw"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rt-private"
  })
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}