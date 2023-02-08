#----------------------------------------------------------
#  - VPC
#  - Internet Gateway
#  - XX Public Subnets
#----------------------------------------------------------

data "aws_availability_zones" "available" {}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(local.common_tags, 
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.tags,
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, 
    {
      "Name" = format("%s", var.ig_name)
    },
    var.tags,
  )
}

#-------------Public Subnets and Routing----------------------------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, 
    {
      "Name" = "${var.subnet_name}-${count.index + 1}"
    },
    var.tags,
  )
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(local.common_tags, 
    {
      "Name" = format("%s", var.rt_name)
    },
    var.tags,
  )
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}



