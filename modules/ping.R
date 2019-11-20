# generic module to find out where your bot is running ####

module.list <- unique(append(module.list, "ping")) # needed for update-module
cat("I was initalized \n")
ping <- function(bot, update){
  err=NA; tryCatch(expr = {
    sysout <- system("ifconfig", intern=T)
    if (update$message$from$id == botmaster) {
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = sysout[grep("br0", sysout)+1])
      
    } else{
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = "Not authorized")
    }
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
}
ping_handler <- CommandHandler("ping",ping)