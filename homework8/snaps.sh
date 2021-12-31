#!/bin/bash

##############################################################################
#### Script prints list of EBS snapshots older than specified numbers of hours
#### shaps.sh -p <period> -n <number> [-t <tag_name>] [-v <tag_value>]
####    -p    : period (min,hour,days)"
####    -n    : number of period's items (integer value)"
####    -t    : Tag name"
####    -v    : Tag value"
##############################################################################

# Define default variables
tag="Name"
value="*"

# Function for printing help message in case of wrong parameters usage
function print_help {
  echo " "
  echo "  Script prints list of EBS snapshots older than specified numbers of hours"
  echo "  Usage: ./snaps.sh -p <period> -n <number> [-t <tag_name>] [-v <tag_value>], where:"
  echo "      -p    : period (min,hour,days)"
  echo "      -n    : number of period's items (integer value)"
  echo "      -t    : Tag name"
  echo "      -v    : Tag value"
  echo " "
  exit 0
}

# Check if the scrip was launcned without arguments
if [ "$#" == 0 ]; then
   print_help
   exit 2
fi

# Check if your AWS credentials ware properly configured
aws sts get-caller-identity > /dev/null 2>&1
if  [ $? != 0 ]
  then
    echo "Please set AWS credentials with  \"aws configure\" command"
    exit 1
fi

# Parsing script parameters
while getopts ":p:n:t:v:" opt; do
  case $opt in
    p)
      period=$OPTARG
      echo "period=" $period
    ;;
    n)
      num=$OPTARG
      echo "num=" $num
    ;;
    t)
      tag=$OPTARG
      echo "tag=" $tag
    ;;
    v)
      value=$OPTARG
      echo "value=" $value
    ;;
    :)
      echo "Missing argument for $OPTARG" >&2
      exit 1
    ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
    ;;
  esac
done

# Bring local time to UTC, taking period and number of items in it into  consideration
time_offset=$(TZ=":UTC" date --date="-"$num"$period" '+%Y-%m-%dT%H:%MZ' 2>/dev/null )

# Check of "period" and "num" parameters are suitable for "date" command
if  [ $? != 0 ]
  then
    print_help
    exit 2
fi

# Print EBS Snapshots
aws ec2 describe-snapshots --owner self --output json  --filters "Name=tag:$tag,Values=$value" | jq '.Snapshots[] | select(.StartTime < "'$time_offset'") | [.SnapshotId, .StartTime, .VolumeSize, (.Tags[]|select(.Key=="'$tag'")|.Value) ]'

exit 0