# Andersen DevOps Training 
## Homework 3
Преобразовать следующий однострочник в красивый скрипт:  
`sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c |
sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP |
awk -F':' '/^Organization/ {print $2}' ; done`

Обязательные пункты:
* создайте README.md и опишите, что будет делать ваш скрипт
* скрипт должен принимать PID или имя процесса в качестве аргумента
* количество строк вывода должно регулироваться пользователем
* должна быть возможность видеть другие состояния соединений
* скрипт должен выводить понятные сообщения об ошибках
* скрипт не должен зависеть от привилегий запуска, выдавать предупреждение

Бонусные пункты:
* скрипт выводит число соединений к каждой организации
* скрипт позволяет получать другие данные из вывода `whois`
* скрипт умеет работать с `ss`, 
* вы используете утилиты/built-ins, не вошедшие в однострочник

##  Name
getconn.sh - get connections

##  Description
Script for getting a list of companies what the particular service is connected to
Script checks prerequisites, and arguments.

## Prerequisites
- root privileges for full information
- whois installed on the system

##  Usage
      getconn.sh <-p PID | -n ProcessName> [-l CompList] [-t netstat|ss] [-h]
        -p
            Process ID number. Mutually exclusive with "-n" key
        -n
            Process Name. Mutually exclusive with "-p" key
        -l
            Length of the output list. Default is full output
        -t
            netstat|ss - which tool to use to get IP addresses list. Default is "netstat"
        -h
            help

## Known bugs
- Output can be inaccurate due to standard key position absence in which  companies provide their names. Some of them use Organization or netname fields, others - in desription field.
- Unpredictable behaviour without arguments. getopts needs further investigation.    

## Possible improvements
- Remove bugs
- Move some parts to the functions
- Reconsider parameters checking and create more sophisticated functions
- Parameter to get connection state (established, closed_wait, etc.)
- Default number of output lines is hardwired. Necessary to find another way to do that.
- Final output table structure is not based on actual output. 
