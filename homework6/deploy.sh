#!/bin/bash

##############################################################
# Dumn script for deploying Cloudformation Template. No checks
# Usage: deploy.sh <cloudformation-template.yaml>
##############################################################


# Function for printing help message in case of wrong parameters usage
function print_help {
  echo " "
  echo "  Script prints list of EBS snapshots older than specified numbers of hours"
  echo "  Usage: ./deploy.sh <cloudformation-template.yaml> , where:"
  echo "      cloudformation-template.yaml    : Cloudformation Template"
  echo " "
  exit 1
}

# Check if the scrip was launcned without arguments
if [ "$#" == 0 ]; then
   print_help
fi

# Check if your AWS credentials ware properly configured
aws sts get-caller-identity > /dev/null 2>&1
if  [ $? != 0 ]
  then
    echo "Please set AWS credentials with  \"aws configure\" command"
    exit 1
fi


aws cloudformation deploy --template-file $1 --stack-name vpc-central --capabilities CAPABILITY_NAMED_IAM