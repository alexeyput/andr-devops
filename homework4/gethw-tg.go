//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
// Description
//   Andersen DevOps training homework 3
//   Telegram bot for homework completion checking, based on Telegram bot API
//
// Files
//  gethw-tg.go  -  source code
//  gethw-tg.yaml -  config file
//  gethw-tg.service - sample systemctl service file
//
// Environment variables
//  TG_TOKEN - token used to connect to Telegram Bot
//  TG_CONFIG_FILE  - path to config file in yaml format
//
// ## Prerequisites
//  - Telegram bot created
//  - go language installed
//  - Telegram API for golang installed
//
// ## How to start
// gethw-tg.go -telegrambottoken <Telegram_token>
//
//  Telegram bot command description
//   /git   -  Get git repository address
//   /tasks -  Get the list of finished homework
//   /task#, where # is a number of task - returns url of the folder with the homework
//   /help - get help message
//
// URL templates
//  GitHub Repository Name:
//      https://github.com/$user_name/$repository_name
//  Homework Folder:
//      https://github.com/$user_name/$repository_name/tree/main/$homework_folder$homework_number
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

package main

import (
	"github.com/Syfaro/telegram-bot-api"
	"log"
	"os"
    "regexp"
    "strings"
    "strconv"
    "net/http"
    "io/ioutil"
    "path/filepath"
    "gopkg.in/yaml.v2"
)

//  Define global variables
    var (
        telegramBotToken string
        tg_command string
        hw_num string
        reply string
        step_str string
    )

// Structure for parameters taken from .yaml config file
type Config struct {
    User_name string  `yaml:"user_name"`
    Repository_name string `yaml:"repository_name"`
    Homework_folder string `yaml:"homework_folder"`
}

//////////////////
// Main app body
/////////////////
func main() {
// Check if environment variables are set
    _, ok := os.LookupEnv("TG_CONFIG_FILE")
     if !ok {
       log.Printf("TG_CONFIG_FILE is not set\n")
       panic(1)
     }
    _, ok = os.LookupEnv("TG_TOKEN")
     if !ok {
       log.Printf("TG_TOKEN is not set\n")
       panic(1)
     }

    filename, _ := filepath.Abs(os.Getenv("TG_CONFIG_FILE"))
    yamlFile, err := ioutil.ReadFile(filename)
    var config Config
    err = yaml.Unmarshal(yamlFile, &config)
    if err != nil {
        panic(err)
    }
    repository_url := "https://github.com/"+config.User_name+"/"+config.Repository_name
    homework_number_template := "https://github.com/"+config.User_name+"/"+config.Repository_name+"/tree/main/"+config.Homework_folder

// Create Bot instance
	bot, err := tgbotapi.NewBotAPI(os.Getenv("TG_TOKEN"))
	if err != nil {
		log.Panic(err)
	}
	log.Printf("Authorized on account %s", bot.Self.UserName)

// Create "u" structure for message updates
	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60
// Create channel using "u" structure
	updates, err := bot.GetUpdatesChan(u)
// Read and deal with updates from the channel
	for update := range updates {
// Default reply
		reply = "Unknown command. \n Issue /help go get help."
		if update.Message == nil {
			continue
		}

// Print message
log.Printf("%s", update.Message.Text)

// Switch structure to process the commands
	tg_command = update.Message.Command()

    switch tg_command  {
            case "git":
                reply =  repository_url
            case "tasks":
              step_int := 1
                for  {
                    step_str = strconv.Itoa(step_int)
                    tasks_reply := homework_number_template+hw_num+step_str
                    resp, _ := http.Get(tasks_reply)
                    if  resp.StatusCode != 200 {
                        reply = ""
                        break
                      }
                    log.Println(tasks_reply)
                    msg := tgbotapi.NewMessage(update.Message.Chat.ID, tasks_reply)
                    bot.Send(msg)
                    step_int++
                }
            case "help":
                reply =  "/git - get the repository URL \n /tasks - get finished homework list \n /task# - get homework# URL \n /help - get this message"
            default:
            	matched, _ := regexp.MatchString(`^task\d*$`, tg_command)
                log.Println(matched)
                if matched {
                    hw_num := strings.Trim(tg_command, "task")
                    reply = homework_number_template+hw_num
                    resp, _ := http.Get(reply)
                    if resp.StatusCode != 200 {
                        reply = "Homework hasn't been finished"
                    }
                }
        }

// Create and send the reply
         log.Println(reply)
		msg := tgbotapi.NewMessage(update.Message.Chat.ID, reply)
		bot.Send(msg)
	}
}