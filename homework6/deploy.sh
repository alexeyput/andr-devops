#!/bin/bash

##############################################################
# Dumn script for deploying Cloudformation Template. No checks
# Usage: deploy.sh <cloudformation-template.yaml>
##############################################################

aws cloudformation deploy --template-file $1 --stack-name vpc-central --capabilities CAPABILITY_NAMED_IAM