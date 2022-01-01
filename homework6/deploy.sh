#!/bin/bash

#########################################################################################
# Dummy script for deploying Cloudformation Template.
#
# Usage:
#  To create infrastructure:
#   deploy.sh <cloudformation-template.yaml> <stack_name> <environment> , where:
#       cloudformation-template.yaml    : Cloudformation Template
#       stack_name                      : Name of the Cloudformation stack to be created
#       environment                     : Environment type (dev, prod, etc.)
#
#   To Destroy infrastructure:
#    deploy.sh destroy <stack_name> , where:
#       stack_name                      : Name of the Cloudformation stack to be created
###########################################################################################

# Function for printing help message in case of wrong parameters usage
function print_help {
  echo " "
  echo "  Script prints list of EBS snapshots older than specified numbers of hours"
  echo "  Usage: "
  echo "  To create infrastructure:"
  echo "  deploy.sh <cloudformation-template.yaml> <stack_name> <environment> , where:"
  echo "      cloudformation-template.yaml    : Cloudformation Template"
  echo "      stack_name                      : Name of the Cloudformation stack to be created"
  echo "      environment                     : Environment type (dev, prod, etc.)"
  echo " "
  echo "  To Destroy infrastructure:"
  echo "  deploy.sh destroy <stack_name> , where:"
  echo "      stack_name                      : Name of the Cloudformation stack to be created"
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

# Delete stack and destroy the infrastructure
if [ $1 == "destroy" ]
  then
    aws cloudformation delete-stack --stack-name $2
    if  [ $? != 0 ]
      then
        echo "Stack deletion failed. Check output and logs"
        exit 1
    fi
    echo "Deletion in progress. Check AWS CloudFormation console for output messages and result"
  exit 0
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