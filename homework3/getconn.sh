#!/bin/bash

################################################################################################
################################################################################################
################################################################################################
######
######  Name
######      getconn - get connections
######
######  Description
######      Script for getting a list of companies what the particular service is connected to
######
######  Usage
######      getconn.sh <-p PID | -n ProcessName> [-l CompList] [-t netstat|ss] [-h]
######        -p
######            Process ID number. Mutually exclusive with "-n" key
######        -n
######            Process Name. Mutually exclusive with "-p" key
######        -l
######            Length of the output list. Default is full output
######       -t
######            netstat|ss - which tool to use to get IP addresses list. Default is "netstat"
######       -h
######            help
######
######  NOTE: Output can be inaccurate due to standard key position absence in which
######        companies provide their names. Some of them use Organization or netname
######        fields, others - in description field. Beware about it!
######
################################################################################################
################################################################################################
################################################################################################

# Set default variables
number_of_lines=9999999
used_tool="netstat"

# Process ID (PID) checking function (-p key)
function process_id_checking {
# Check if "Process ID" and "Process Name" are set at the same time
  if [[ -n "$process_name" ]]
    then
      print_error_message
  fi
# Check if PID passed as a parameter
  if [[ $1 =~ ^-?[0-9]+$ ]]
    then
# Check if the process with given ID is running on the system
      if ps -p "$1" > /dev/null 2>&1
      then
        process_id="$1"
        process_name=$( ps -q "$1" --no-headers | awk '{print $NF}' )
        else
          echo "There are no processes with PID \"$1\" running on the system"
          exit 1
      fi
      else
        print_error_message
  fi
}

# Process Name checking function (-n key)
function process_name_checking {
# Check if "Process ID" and "Process Name" are set at the same time
  if [[ -n "$process_id" ]]
  then
      print_error_message
  elif [[ -z $(pgrep "$1") ]]
  then
    echo "There are no processes $1 on the system"
    exit 1
  fi
  process_name=$1
}

# Number of lines checking function (-l key)
function number_of_lines_checking {
    if [[ $1 =~ ^-?[0-9]+$ ]]
      then
          number_of_lines=$1
      else
       print_error_message
    fi
}

# Providing help function (-h key)
function print_help {
  echo "  Script for getting a list of companies what the particular service is connected to"
  echo "  Usage: getconn.sh <-p PID | -n ProcessName> [-l CompList] [-t netstat|ss] [-h]"
  echo "          -p Process ID number. Mutually exclusive with -n key"
  echo "          -n Process Name. Mutually exclusive with -p key"
  echo "          -l Output list length. Default is full output"
  echo "          -t netstat|ss - which tool to use to get IP addresses list. Default is netstat"
  echo "          -h - which tool to use to get IP addresses list"
  exit 0
}

# Message in case something wrong with the arguments
function print_error_message {
  echo "Wrong usage. Use \"getconn -h\" for help"
  exit 1
}

# Select tool used for getting IP addresses list - "netstat" or "ss"
function tool_to_be_used {
  if [[ $1 == "netstat" ]]
  then
    used_tool="netstat"
  elif [[ $1 == "ss" ]]
  then
    used_tool="ss"
  else
    echo "Use \"netstat\" or \"ss\" with the \"-t\" key"
    exit 1
fi
}

# Get list of IP addresses using "netstat" or "ss" utility
function get_ip_list {
  if [[ "$used_tool" == "netstat" ]]
  then
    ip_addresses_list="$( netstat -tunap 2>/dev/null | grep "$process_name"  | awk '{print $5 " " $6 } ' | sed 's/\:[[:digit:]]\+/ /g' | sed -e /0.0.0.0/d | sort | uniq -c | tail -n "$number_of_lines" )"
  else
    ip_addresses_list="$( ss -tunap 2>/dev/null | grep "$process_name"  | awk '{print $6 " " $2 } ' | sed 's/\:[[:digit:]]\+/ /g' | sed -e /0.0.0.0/d | sort | uniq -c | tail -n "$number_of_lines" )"
  fi
}

###########################
#### Main program body ####
###########################
# Parsing script arguments
while getopts ":p:t:n:l:h" opt; do
  case $opt in
    p)
      process_id_checking "$OPTARG"
    ;;
    t)
      tool_to_be_used "$OPTARG"
    ;;
    n)
      process_name_checking "$OPTARG"
    ;;
    l)
      number_of_lines_checking "$OPTARG"
    ;;
    h)
      print_help
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

# Extra check if script doesn't have any arguments
# getopts doesn't work properly for some reason.
# Further investigation in necessary
  if [[ -z "$process_id" ]] && [[ -z "$process_name" ]]
  then
      print_error_message
      exit 1
  fi

# Check root privileges
  if [[ $(id -u) != 0 ]]
    then
      echo "No root privileges. Not all connections will be displayed"
  fi

# Check if whois installed on the system
  whois > /dev/null 2>&1
  if [[ $? != 1 ]]
    then
      echo "whois utility needs to be installed."
      echo "Please install and run again"
      exit 1
  fi

# Call function to get ip list which the process connected to
get_ip_list

# Check whether the process has active connections to remote servers
  if [[ -z "$ip_addresses_list" ]]
  then
    echo "The process doesn't have any active opened connections to remote sites"
    exit 1
  fi

# Get information about Companies using prepared IP addressed list and whois service and print in table format
echo "===================="
echo "Process Name:""$process_name"
echo "Used tool:" "$used_tool"
echo "===================="
echo -e "IP address \t\t Company Name \t\t  Connection state \t\t Number of connections"
  while read -r "IP"
    do
      ip_address="$(echo "$IP" | awk '{print $2}')"
      company_name="$(whois  "$ip_address" |   awk -F':' '/^Organization|netname/ {print $2}' | sed 's/^\s*//')"
      connections_number="$(echo "$IP" | awk '{print $1}')"
      connections_state="$(echo "$IP" | awk '{print $3}')"
      echo -e "$ip_address" "\t\t" "$company_name" "\t\t" "$connections_state" "\t\t"  "$connections_number"
    done <<< "$ip_addresses_list"

exit 0