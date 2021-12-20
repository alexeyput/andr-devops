
# Create Security Groups
resource "aws_security_group" "ssh_sec_group" {
  name = "ssh_sec_group"
  vpc_id = aws_vpc.vpc_tf.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #    ingress {
  #        from_port = 80
  #        to_port = 80
  #        protocol = "tcp"
  #        cidr_blocks = ["0.0.0.0/0"]
  #    }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name: "${var.env_prefix}-sg"
  }
}

resource "aws_security_group" "http_sec_group" {
  name = "http_sec_group"
  vpc_id = aws_vpc.vpc_tf.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name: "${var.env_prefix}-sg"
  }
}
