resource "aws_internet_gateway" "terraform-lab-igw" {
  tags = {
    Name = "terraform-lab-igw"
  }
  vpc_id = aws_vpc.terraform-lab-vpc.id
}

#create Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.terraform-lab-igw.id
  destination_cidr_block = "0.0.0.0/0"
}