# Nat40_ ####

# # # # # # # #

# clear workspace ####

rm(list = ls())

# set environment path ####
# if(length(Sys.getenv("BotspacePath"))!=0) setwd(Sys.getenv("BotspacePath"))

# include libraries ####
library(tidyverse);library(telegram.bot)

# load environment ####

currentScript <- "PaperTron.R"
botmaster <- Sys.getenv("botmaster_token") # The botmaster_token 
updater <- Updater(token = Sys.getenv("PaperTron_bot"));module.list=c()


# static variables for modules####

# static variables ####
welcome_message <-  sprintf("")


# loading modules ####
source("modules/update.R")
source("modules/start.R")
source("modules/ping.R")
source("modules/kill.R")
source("modules/papertron.R")

source("modules/unknown.R")

updater1 <- updater +update_handler+ start_handler+kill_handler+ping_handler+collection_handler+ papertron_handler
updater1$start_polling(verbose=T)
