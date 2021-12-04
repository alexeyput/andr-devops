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
2. Copy files
```
sudo cp ./gethw-tg /opt/gethw-tg
sudo cp ./gethw-tg.yaml /opt/gethw-tg
sudo cp ./gethw-tg.service /etc/systemd/system
```
3. ############### Create user for the service
```
useradd gethw_tg
```
4. Start service and enable autostart
```
sudo systemctl daemon-reload
sudo systemctl start gethw-tg start
sudo systemctl enable gethw-tg 
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
