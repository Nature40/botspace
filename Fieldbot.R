# Nat40_ ####

# # # # # # # #

# clear workspace ####

rm(list = ls())

# set environment path ####
if(length(Sys.getenv("BotspacePath"))!=0) setwd(Sys.getenv("BotspacePath"))

# include libraries ####
library(tidyverse);library(telegram.bot)

# load environment ####

currentScript <- "Fieldbot.R"
botmaster <- Sys.getenv("botmaster_token") # The botmaster_token 
updater <- Updater(token = bot_token("Nat40_Fieldbot"));module.list=c()




# static variables for modules####

# static variables ####
welcome_message <-  sprintf("Hi, I am Fieldbot")


# loading modules ####
source("modules/update.R")
source("modules/start.R")
source("modules/ping.R")
source("modules/kill.R")

source("modules/PollHandler.R")
source("modules/maintenance.R")
source("modules/verbose.R")
source("modules/unknown.R")

updater1 <- updater +update_handler+ 
  start_handler+kill_handler+
  ping_handler+bbx_handler +poll_handler#+verbose_handler + verbose_handler2
updater1$start_polling(verbose=T)
