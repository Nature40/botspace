module.list <- unique(append(module.list, "skeleton"))
cat("I was initalized \n")
skeleton <- function(bot, update){
  err=NA; tryCatch(expr = {
    
    # Insert your Bot Module here ####
    
    
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
  
}
skeleton_handler <- CommandHandler("skeleton", skeleton)