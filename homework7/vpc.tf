# Create VPC
resource "aws_vpc" "vpc_tf" {
    cidr_block = var.cidr_blocks
    tags = {
        Name:  "${var.env_prefix}-vpc"
    }
}



