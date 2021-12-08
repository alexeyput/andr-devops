# Andersen DevOps Training 

## Homework 4
Написать функционирующего телеграмм бота на языке GO имеющего минимум 3 команды:
- Git возвращает адрес вашего репозитория.
- Tasks возвращает нумерованный список ваших выполненных заданий.
- Task#, где # номер задания, возвращает ссылку на папку в вашем репозитории с выполненной задачей.

##  Name
Telegram Bot:  
github_check_2230_bot

##  Description
Telegram bot for homework completion checking  
Based on Telegram bot API: https://github.com/go-telegram-bot-api/telegram-bot-api  
User **gethw-tg** is used for the service startup for security reasons

## Files
| File | Description | 
| --- | --- |
| gethw-tg.go  |  source code |   
| gethw-tg.yaml |  config file  |   

## Configuration
### Environment variables:
Set the following variables before starting the bot
- TG_TOKEN - token used to connect to Telegram Bot
- TG_CONFIG_FILE  - path to config file in **yaml** format
### Yaml config file parameters
- user_name - GitHub login user name 
- repository_name - GitHub repository name
- homework_folder - Folders for the homework within the repository 

## Prerequisites
- Telegram bot
- go language installed
```
sudo apt install golang-go
```
- Telegram API for go  
```
go get github.com/Syfaro/telegram-bot-api
```

## Installation
1. Build artefact
```
go build gethw_tg.go
```
2. Create application folder
```
mkdir -p /opt/gethw-tg
```
3. Insert Telegtam token into 
```
gethw-install.sh
``` 
4. Copy files and set privileges
```
sudo cp -rf ./gethw-tg /opt/gethw-tg
sudo cp -rf ./gethw-tg.yaml /opt/gethw-tg
sudo cp -rf ./gethw-tg.service /etc/systemd/system
chown -R gethw-tg:gethw-tg /opt/gethw-tg
chmod -R 775 /opt/gethw-tg
```
5. Create user for the service
```
useradd -M  -s /usr/sbin/nologin gethw-tg
```
6. Start service and enable autostart
```
sudo systemctl daemon-reload
sudo systemctl start gethw-tg start
sudo systemctl enable gethw-tg 
```
Alternatively you can start installation script. The script doesn't check performing commands so do it manually.
```
sudo ./gethw-install.sh
```

##  Telegram Bot commands list
```
/git   -  Get git repository address
/tasks -  Get the list of finished homework
/task#, where # is a number of task - returns url of the folder with the homework
/help - get help message
```
## Known bugs
Script check HW folders consequently, i.e homework1,homework2,etc. script stops checking URLs after the first gap in sequence.  

## Possible improvements
- Remove bugs
- Add buttons
- Add dedicated function to send reply and call it from the application body
- Add more checking procedures in installation script
- Use module **go-git** of similar to get info via Git API
