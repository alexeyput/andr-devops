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
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id = aws_subnet.public_subnet-A.id
  vpc_security_group_ids = [aws_security_group.ssh_sec_group.id]
  availability_zone = var.avail_zone[0]
  key_name = var.keyname
  associate_public_ip_address = true
  tags = {
    Name: "${var.env_prefix}-public-A"
  }
  user_data = file("init-bastion.sh")
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
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id = aws_subnet.private_subnet-A.id
  vpc_security_group_ids = [aws_security_group.ssh_sec_group.id, aws_security_group.http_sec_group.id ]
  availability_zone = var.avail_zone[0]
  key_name = var.keyname
  associate_public_ip_address = false
  tags = {
    Name: "${var.env_prefix}-private-A"
  }
  user_data = file("init-web.sh")
  #    provisioner "file" {
  #        source      = "~/Downloads/AWS-default-key.pem"
  #        destination = "~/.ssh"
  #
  #        connection {
  #            type        = "ssh"
  #            user        = "ec2-user"
  #            private_key = file("~/Downloads/AWS-default-key.pem")
  #            host        = self.public_dns
  #        }
  #    }

}

resource "aws_instance" "private-instance-B" {
  ami =  data.aws_ami.latest-linux-image.id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id = aws_subnet.private_subnet-B.id
  vpc_security_group_ids = [aws_security_group.ssh_sec_group.id, aws_security_group.http_sec_group.id]
  availability_zone = var.avail_zone[1]
  key_name = var.keyname
  associate_public_ip_address = false
  tags = {
    Name: "${var.env_prefix}-private-B"
  }
  user_data = file("init-web.sh")
}
