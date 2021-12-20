
# Create subnets
resource "aws_subnet" "public_subnet-A" {
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.public_subnets_cidr_blocks[0]
  availability_zone = var.avail_zone[0]
  tags = {
    Name: "${var.env_prefix}-public-subnet-A"
  }
}
resource "aws_subnet" "public_subnet-B" {
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.public_subnets_cidr_blocks[1]
  availability_zone = var.avail_zone[1]
  tags = {
    Name: "${var.env_prefix}-public-subnet-B"
  }
}
resource "aws_subnet" "private_subnet-A" {
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.private_subnets_cidr_blocks[0]
  availability_zone = var.avail_zone[0]
  tags = {
    Name: "${var.env_prefix}-private-subnet-A"
  }
}
resource "aws_subnet" "private_subnet-B" {
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.private_subnets_cidr_blocks[1]
  availability_zone = var.avail_zone[1]
  tags = {
    Name: "${var.env_prefix}-private-subnet-B"
  }
}