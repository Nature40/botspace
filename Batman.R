# Nat40_Batman ####

# # # # # # # #

# clear workspace ####

rm(list = ls())

# set environment path ####
if(length(Sys.getenv("BotspacePath"))!=0) setwd(Sys.getenv("BotspacePath"))

# include libraries ####
library(tidyverse);library(telegram.bot)

# load environment ####

currentScript <- "Batman.R"
botmaster <- Sys.getenv("botmaster_token") # The botmaster_token 
updater <- Updater(token = bot_token("Nature40_Batman"));module.list=c()


# static variables for modules####

welcome_message <-  sprintf("I am Batman. I may help you in your bat related projects.")

# loading modules ####

source("modules/update.R")
source("modules/start.R")
source("modules/ping.R")
source("modules/kill.R")
source("modules/bat.R")
source("modules/unknown.R")


# Build update handler #### 

updater1 <- updater + update_handler + start_handler + kill_handler + ping_handler + bat_handler

updater1$start_polling(verbose=T)
