# Nat40_MediaCrawler ####

# # # # # # # #

# clear workspace ####

rm(list = ls())

# set environment path ####
if(length(Sys.getenv("BotspacePath"))!=0) setwd(Sys.getenv("BotspacePath"))

# include libraries ####
library(tidyverse);library(telegram.bot)

# load environment ####

currentScript <- "MediaCrawler.R"
botmaster <- Sys.getenv("botmaster_token") # The botmaster_token 
updater <- Updater(token = bot_token("Nature40_MediaCrawler"));module.list=c()


# static variables for modules####

# static variables ####
welcome_message <-  sprintf("I am the Media Crawler. My sole purpose is saving and storing photos and videos from our various telegram group chats.")


# loading modules ####
source("modules/update.R")
source("modules/start.R")
source("modules/ping.R")
source("modules/kill.R")
source("modules/mediacrawl.R")
source("modules/unknown.R")

updater1 <- updater +update_handler+ start_handler+kill_handler+ping_handler+media_handler
updater1$start_polling(verbose=T)
