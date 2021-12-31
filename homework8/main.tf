##################################################################################
#### Terraform Template creates EBS Volume and several snaps  (3 by default) based on this volume
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

locals {
  timestamp = "${timestamp()}"
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"

}

# How many snapshots need to be created, default is 3
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
  description = "Snap${count.index}_${local.timestamp_sanitized}"
  tags = {
    Name = "Snap_${local.timestamp_sanitized}"
  }
}


