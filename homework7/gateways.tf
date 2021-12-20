# Create Public NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  subnet_id = aws_subnet.public_subnet-A.id
  allocation_id = aws_eip.elastic_ip.id
  connectivity_type = "public"
  tags = {
    Name = "${var.env_prefix}-NAT-gateway"
  }
  depends_on = [aws_internet_gateway.myInternetGateway]
}

# Create Elastic IP
resource "aws_eip" "elastic_ip" {
  vpc = true
  depends_on = [aws_internet_gateway.myInternetGateway]
}

# Create Internet Gateway
resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name: "${var.env_prefix}-internet-gateway"
  }
}
