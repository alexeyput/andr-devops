
# Create S3 bucket
resource "aws_s3_bucket" "tf-s3-bucket-alexeyput" {
  bucket = "tf-s3-bucket-alexeyput"
  acl    = "private"

  tags = {
    Name        = "tf-s3-bucket-alexeyput"
    Environment = "Dev"
  }
}

# Create S3 endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc_tf.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  #     service_name = "com.amazonaws.eu-central-1.s3"
  route_table_ids = [aws_route_table.privateRouteTable.id]
  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}

