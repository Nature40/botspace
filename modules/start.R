# generic module for welcome messages needed for every bot ####

module.list <- unique(append(module.list, "start")) # needed for update-module
if(!exists("welcome_message")) {stop("You need to define a 'welcome_message' to use this module.") # define in bot main function 
}else{
  cat("I was initalized \n")
  start <- function(bot, update){
    err=NA; tryCatch(expr = {
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = sprintf("Hello %s!", update$message$from$first_name))
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = welcome_message)
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = sprintf("I was written by Friessn in R. Contact: friess@staff.uni-marburg.de or https://github.com/friessn"))
    },
    error = function(e) {err<<-e},silent = T)
    if(!is.na(err)){
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = paste("An error occurred \n",gsub("<simple", "", err),
                                   "\n You should contact the bot master. \n"))
    }
    
  }
}
start_handler <- CommandHandler("start", start)