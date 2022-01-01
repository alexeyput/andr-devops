#!/bin/bash

##############################################################
# Dummy script for deploying Cloudformation Template. No checks
# Usage: deploy.sh <cloudformation-template.yaml> <stack_name> <environment>
##############################################################

# Function for printing help message in case of wrong parameters usage
function print_help {
  echo " "
  echo "  Script prints list of EBS snapshots older than specified numbers of hours"
  echo "  Usage: ./deploy.sh <cloudformation-template.yaml> <stack_name> <environment> , where:"
  echo "      cloudformation-template.yaml    : Cloudformation Template"
  echo "      stack_name                      : Name of the Cloudformation stack to be created"
  echo "      environment                     : Environment type (dev, prod, etc.)"
  echo " "
  exit 1
}

# Check if the script was launched without arguments
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

# Main magic happens here
aws cloudformation deploy --template-file $1 --stack-name $2 --parameter-overrides  Environment="$3" --capabilities CAPABILITY_NAMED_IAM

# Check if the infrastructure wes created
if  [ $? != 0 ]
  then
    echo "Something went wrong. Need more gold..."
    exit 1
fi

exit 0