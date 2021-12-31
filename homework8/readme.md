# Andersen DevOps online training 11-12.2021

## Homework 8
![Домашка](https://github.com/alexeyput/andr-devops/blob/main/homework8/Homework8.png?raw=true)

## Name
Homework 8. Cloud tools

## Description
Script prints a list of EBS snapshots older than specified numbers of hours.  
Optionally you cat specify tag name and tag value as a filter

## Usage
     shaps.sh -p <period> -n <number> [-t <tag_name>] [-v <tag_value>]   
        -p    : period (min,hour,days)   
        -n    : number of period's items (integer value)   
        -t    : Tag name
        -v    : Tag value   

## Prerequisites
- asw cli installed
- aws credentials configured

## Terraform template
You can use terraform template to create a EBS Volume and a set (3 by default) of its's snapshots.

```
 Terraform init
```
To check what will be created:
```
 terraform plan
```
To create:
```
 terraform apply [--auto-approve ]
```
To destroy:
```
 terraform destroy [--auto-approve ]
```

If you need more snapshots, created after particular period of time you should create them manually from AWS console

## Possible emprovements
- Alter script to create several snaps in a perticular period of time one by one