
# Create Public Routing table
resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }
  tags = {
    Name: "${var.env_prefix}-public-route-table"
  }
}
resource "aws_route_table_association" "pubA-route-association" {
  subnet_id = aws_subnet.public_subnet-A.id
  route_table_id = aws_route_table.publicRouteTable.id
}
resource "aws_route_table_association" "pubB-route-association" {
  subnet_id = aws_subnet.public_subnet-B.id
  route_table_id = aws_route_table.publicRouteTable.id
}

# Create Private Routing table
resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name: "${var.env_prefix}-private-route-table"
  }
}
resource "aws_route_table_association" "prvA-route-association" {
  subnet_id = aws_subnet.private_subnet-A.id
  route_table_id = aws_route_table.privateRouteTable.id
}
resource "aws_route_table_association" "prvB-route-association" {
  subnet_id = aws_subnet.private_subnet-B.id
  route_table_id = aws_route_table.privateRouteTable.id
}
