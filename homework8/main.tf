##################################################################################
#### Terraform Template creates EBS Volume and several storages based on this volume
#### Terraform init
#### To check what will be created:
#### terraform plan
#### To create:
#### terraform apply --auto-approve
#### To destroy:
#### terraform destroy --auto-approve
##################################################################################

provider "aws" {
  region = "eu-central-1"
}

# How many snapshots need to be created, default is 3
variable "snaps_count" {
  default = 3
}

variable "snaps_count" {
  default = 3
}

resource "aws_ebs_volume" "ebs_vol_1" {
  availability_zone = "eu-central-1a"
  type = "standard"
  size              = 1

  tags = {
    Name = "Volume_1"
  }
}

resource "aws_ebs_snapshot" "Volume_1_snaps" {
  count = var.snaps_count
  volume_id = aws_ebs_volume.ebs_vol_1.id
  description = "Snap${count.index}"
  tags = {
    Name = "Volume_1_snap_${count.index}"
  }
#  provisioner "local-exec" {
#    command = "sleep 10m"  # for sleep 10 min
#  }
}

#resource "aws_ebs_snapshot" "Volume_1_snap_2" {
#  volume_id = aws_ebs_volume.ebs_vol_1.id
#  description = "Snap2"
#
#  tags = {
#    Name = "Volume_1_snap_2"
#  }
#}
#
#resource "aws_ebs_snapshot" "Volume_1_snap_3" {
#  volume_id = aws_ebs_volume.ebs_vol_1.id
#  description = "Snap3"
#
#  tags = {
#    Name = "Volume_1_snap_3"
#  }
#}
