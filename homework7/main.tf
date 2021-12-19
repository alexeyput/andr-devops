provider "aws" {
    region = "eu-central-1"
}

# Define variables
variable cidr_blocks {}
variable public_subnets_cidr_blocks {}
variable private_subnets_cidr_blocks {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}
variable keyname {}
variable aws_region {}

# Create VPC
resource "aws_vpc" "vpc_tf" {
    cidr_block = var.cidr_blocks
    tags = {
        Name:  "${var.env_prefix}-vpc"
    }
}

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

# Create Public Ec2 instances
data "aws_ami" "latest-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "bastion-host" {
    ami =  data.aws_ami.latest-linux-image.id
    instance_type = var.instance_type
    iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
    subnet_id = aws_subnet.public_subnet-A.id
    vpc_security_group_ids = [aws_security_group.ssh_sec_group.id]
    availability_zone = var.avail_zone[0]
    key_name = var.keyname
    associate_public_ip_address = true
    tags = {
        Name: "${var.env_prefix}-public-A"
    }
    user_data = "${file("init-bastion.sh")}"
}

#resource "aws_instance" "public-instance-B" {
#    ami =  data.aws_ami.latest-linux-image.id
#    instance_type = var.instance_type
#    iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
#    subnet_id = aws_subnet.public_subnet-B.id
#    vpc_security_group_ids = [aws_security_group.ssh_sec_group.id]
#    availability_zone = var.avail_zone[1]
#    key_name = var.keyname
#    associate_public_ip_address = true
#    tags = {
#        Name: "${var.env_prefix}-public-B"
#    }
#    user_data = "${file("init.sh")}"
#}

resource "aws_instance" "private-instance-A" {
    ami =  data.aws_ami.latest-linux-image.id
    instance_type = var.instance_type
    iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
    subnet_id = aws_subnet.private_subnet-A.id
    vpc_security_group_ids = [aws_security_group.ssh_sec_group.id, aws_security_group.http_sec_group.id ]
    availability_zone = var.avail_zone[0]
    key_name = var.keyname
    associate_public_ip_address = false
    tags = {
        Name: "${var.env_prefix}-private-A"
    }
    user_data = "${file("init-web.sh")}"
}

resource "aws_instance" "private-instance-B" {
    ami =  data.aws_ami.latest-linux-image.id
    instance_type = var.instance_type
    iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
    subnet_id = aws_subnet.private_subnet-B.id
    vpc_security_group_ids = [aws_security_group.ssh_sec_group.id, aws_security_group.http_sec_group.id]
    availability_zone = var.avail_zone[1]
    key_name = var.keyname
    associate_public_ip_address = false
    tags = {
        Name: "${var.env_prefix}-private-B"
    }
    user_data = "${file("init-web.sh")}"
}

# Create Application Load Balancer v2
resource "aws_alb" "alb" {
    name            = "terraform-example-alb"
    security_groups = [aws_security_group.http_sec_group.id]
    subnets         = ["${aws_subnet.public_subnet-A.id}", "${aws_subnet.public_subnet-B.id}"]
#    subnets         = ["aws_subnet.private_subnet-A.id", "aws_subnet.private_subnet-B.id"]
    tags = {
        Name: "${var.env_prefix}-ALB"
    }
}
# Create Listener
resource "aws_alb_listener" "listener_http" {
    load_balancer_arn = "${aws_alb.alb.arn}"
    port              = "80"
    protocol          = "HTTP"
    default_action {
        target_group_arn = "${aws_alb_target_group.target_group.arn}"
        type             = "forward"
    }
}
# Create Target Groups for the Load Balancer
resource "aws_alb_target_group" "target_group" {
    name     = "alb-target-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = "${aws_vpc.vpc_tf.id}"
    target_type = "instance"
    health_check {
        path = "/"
        port = 80
    }
}

resource "aws_lb_target_group_attachment" "register-private-instance-A" {
    target_group_arn = aws_alb_target_group.target_group.arn
    target_id        = aws_instance.private-instance-A.id
    port             = 80
}

resource "aws_lb_target_group_attachment" "register-private-instance-B" {
    target_group_arn = aws_alb_target_group.target_group.arn
    target_id        = aws_instance.private-instance-B.id
    port             = 80
}

# Create IAM Role and policy
resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2_instance_profile"
    role = "${aws_iam_role.es2_iam_role.name}"
}

resource "aws_iam_role_policy" "iam_policy" {
    name = "iam_policy"
    role = aws_iam_role.es2_iam_role.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:*",
                ]
                Effect   = "Allow"
                Resource = "*"
            },
        ]
    })
}
resource "aws_iam_role" "es2_iam_role" {
    name = "es2_iam_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },]
    })
}

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
    route_table_ids = ["${aws_route_table.privateRouteTable.id}"]
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

# Outputs
output "bastion_host_ip" {
    description = "Bastion host public IP address"
    value = aws_instance.bastion-host.public_ip
}
output "load_balancer_domain_name" {
    description = "Application Load Balancer domain name"
    value = aws_alb.alb.dns_name
}
