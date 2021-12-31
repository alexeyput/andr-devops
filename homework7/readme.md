# Andersen DevOps online course 11-12.2021 

## Homework 7
### Опциональная домашка :
Написать Terraform template для диаграммы

![Диаграмма](https://github.com/alexeyput/andr-devops/blob/main/homework7/Homework7.png?raw=true)

### Доп .челлендж :
- Сделать тоже самое но в Azure ARM или GCP Deploy Manager и перерисовать диаграмму
- Для AWS обновить диаграмму, добавить упущенные сущности.
- Для AWS EC2 добавить опцию AutoRecovery.
- Написать скрипт обертку и добавить возможность запускать разные Envs с разными параметрами
### Ref. Docs :
- https://www.terraform.io/docs/providers/index.html
- https://www.terraform.io/docs/index.html
- https://registry.terraform.io/browse/providers
- https://www.terraform.io/docs/language/functions/index.html
- https://learn.hashicorp.com/tutorials/terraform/troubleshooting-workflow?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS


## Name
Homework 7. IaaC. Terraform

## Description
Terraform template to rolling out the following infrastructure in AWS:
- VPC in two Availability Zones
- Public and Private subnets in every AZ
- Two EC2 in private subnets as Web-servers
- EC2 instance in a private subnet as a Bastion host. The aim is to get an ssh access to EC2 instances in private subnets
- NAT Gateway as the Internet access point for the Web-servers (OS updates, etc.)
- Internet gateway for public networks
- S3 Bucket for backup purposes (Web-servers copy their sites data to S3).
- VPC endpoint to transred to the S3 through the AWS Backbone Network
- IAM Role is created to access the Web-servers to the S3
- Application Load Balancer to balance workload between the Web-servers

## High-level diagram of the infrastructure
![Dia](https://github.com/alexeyput/andr-devops/blob/main/homework6/Dia/HW6-Dia.png?raw=true)

## Prerequisities
- Terraform installed.
- AWS CLI installed with the AWS Cloud ccess configured.

## Configuration parameters (terraform.tfvars file)
| File | Description | Default value |
| --- | --- | --- |
| cidr_blocks | VPC CIDR Block | "10.0.0.0/16"  |
| public_subnets_cidr_blocks | Private subnets A and B CIDR Blocks | ["10.0.41.0/24","10.0.42.0/24"] |
| private_subnets_cidr_blocks | Public subnets A and B CIDR Blocks | ["10.0.51.0/24","10.0.52.0/24"] |
| avail_zone | Availability Sones A and B | ["eu-central-1a", "eu-central-1b"]                       |
| aws_region | AWS Region | "eu-central-1"                                                           |
| env_prefix | Environment | "dev"                                                                   |
| instance_type | EC2 Instances  type | "t2.micro"                                                   |
| keyname | ssh keys | "AWS-default-key"                                                             |

## Usage
Initialise terraform providers
```
   terraform plan
```
To create plan and simulate infrastructure creation
```
   terraform plan
```
To perform infrastructure creation
```
   terraform apply [-auto-approve]
```
To delete createn infrastructure.
##### NOTE. S3 Bucket will not be deleted in case of having stored objects. Please check and delete manually if it necessary.
```
   terraform destroy [-auto-approve]
```

## Possible improvements
- Configure SSH agent to login to web servers via Bastion host
  https://towardsdatascience.com/connecting-to-an-ec2-instance-in-a-private-subnet-on-aws-38a3b86f58fb#:~:text=Connecting%20to%20a%20private%20subnet,use%20SSH%20keys%20for%20authentication.
- Define Modules