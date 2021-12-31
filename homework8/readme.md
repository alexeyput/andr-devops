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

