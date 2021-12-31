# Andersen DevOps online course 11-12.2021

## Homework 6
### Опциональная домашка :
Написать AWS CloudFormation template для диаграммы

![Диаграмма](https://github.com/alexeyput/andr-devops/blob/main/homework6/Homework6.png?raw=true)

### Доп .челлендж :
- Сделать тоже самое но в Azure ARM или GCP Deploy Manager и перерисовать диаграмму
- Для AWS обновить диаграмму, добавить упущенные сущности.
- Для AWS EC2 добавить опцию AutoRecovery.
- Написать скрипт обертку и добавить возможность запускать разные Envs с разными параметрами
### Ref. Docs :
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html  
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html  
- https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview  
- https://cloud.google.com/deployment-manager/docs  
- https://en.wikipedia.org/wiki/Infrastructure_as_code  
- https://www.terraform.io/docs/providers/index.html  
- https://www.terraform.io/docs/index.html  
- https://registry.terraform.io/browse/providers  

## Name
Homework 6. Infrastructure as a Code. AWS Cloud Formation

## Description
AWS Cloud template to rolling out the following infrastructure in AWS:
- VPC in two Availability Zones
- Public and Private subnets in every AZ
- Two EC2 in private subnets as Web-servers
- EC2 instance in a private subnet as a Bastion host. The aim is to get an ssh access to EC2 instances in private subnets
- NAT Gateway as the Internet access point for the Web-servers (OS updates, etc.)
- Internet gateway for public networks
- S3 Bucket for backup purposes (Web-servers copy their sites' data to S3).
- VPC endpoint to transferred to the S3 through the AWS Backbone Network
- IAM Role is created to access the Web-servers to the S3
- Application Load Balancer to balance workload between the Web-servers

## High-level diagram of the infrastructure
![Dia](https://github.com/alexeyput/andr-devops/blob/main/homework6/Dia/HW6-Dia.png?raw=true)

## Prerequisites
- AWS CLI installed with the AWS Cloud access configured.

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
Use either AWS Cloudformation Console to create an infrastructure or bash script
```
   deploy.sh <cloudformation-template.yaml>
```

## Possible improvements
- Configure SSH agent to login to web servers via Bastion host
  https://towardsdatascience.com/connecting-to-an-ec2-instance-in-a-private-subnet-on-aws-38a3b86f58fb#:~:text=Connecting%20to%20a%20private%20subnet,use%20SSH%20keys%20for%20authentication.
