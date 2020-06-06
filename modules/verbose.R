module.list <- unique(append(module.list, "verbose"))
cat("I was initalized \n")
verbose <- function(bot, update){
  err=NA; tryCatch(expr = {
    
   # print(as.list(update))
    print(as.list(update))
    
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
  
}
verbose_handler <- MessageHandler(verbose)
verbose_handler2 <- PollHandler(verbose)
