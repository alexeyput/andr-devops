# Andersen DevOps online training 11-12.2021

## Homework 2
### Task: 
_**To Create python3+flask application and deploy it using ansible.**_

## Description
Sample web page which shows your IP address, Hostname and OS

## Prerequisities (for Debian 10. May vary for your debian-based linux distro)
- Generate and copy keys with  
`ssh-keygen`  
`ssh-copy-id`

- Change "PermitRootLogin" to  "yes" in  
`/etc/ssh/sshd_config`  
and restart sshd sevice  
`systemctl daemon-reload`  
`systemctl restart sshd`  
- Comment out CD/DVD repositories in  
`/etc/apt/sources.list`  

## QuickStart
Adjust configuration parameters in group_vars/debian10_server.yaml file:

| Parameter | Description |
| ------ | ------ |
| application_name | Name given to your application |
| web_user_name    | Linux user name used to start the application |
| web_group_name   | Linux group name used to start the application |
| flask_port       | TCP port used to access the application |

## Installatioin
To deploy application run on Ansible Master Node

`
ansible-playbook playbook.yaml
`

## How it works
The main steps are the following:
- Update OS on target servers 
- Install packages required for the application on the target servers
- Copy necessary files to the target servers using ansible.builtin.copy - NEEDS TO BE CHANGED
- Create Linux group and user to start the application service under
- Create and start the application service for systemd
- Test web server accessibility

## Known issues
To be done in case of discovering

## Possible improvements
- Create initial configuration shell script for performing prerequisite tasks (RSA keys, config files changing and so on).
- Create Virtual Environment

## Info to take into consideration
https://www.digitalocean.com/community/tutorials/how-to-make-a-web-application-using-flask-in-python-3-ru





