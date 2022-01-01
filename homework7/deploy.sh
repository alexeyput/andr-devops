#!/bin/bash

##############################################################
# Dummy script for deploying Cloudformation Template. No checks
# Usage: deploy.sh <environment | destroy>
##############################################################

# Function for printing help message in case of wrong parameters usage
function print_help {
  echo " "
  echo "  Script prints list of EBS snapshots older than specified numbers of hours"
  echo "  Usage: deploy.sh <environment | destroy> , where:"
  echo "      environment      : Environment type (dev, prod, etc.)"
  echo "      destroy          : Use to destroy previously created environment"
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

# initialize terraform providers
terraform init
if  [ $? != 0 ]
  then
    echo "Something went wrong. terraform init failed."
    exit 1
fi

if [ $1 == "destroy" ]
  then
    terraform destroy -auto-approve
    if  [ $? != 0 ]
      then
        echo "Something went wrong. terraform destroy failed. Check output and logs"
        exit 1
    fi
  exit 0
fi


# check terraform plan
terraform plan
if  [ $? != 0 ]
  then
    echo "Something went wrong. terraform plan failed. Check output and logs"
    exit 1
fi

# deploy infrastructure
terraform apply  -var env_prefix=”$1” -auto-approve
if  [ $? != 0 ]
  then
    echo "Something went wrong. terraform plan failed. Check output and logs"
    exit 1
fi

exit 0