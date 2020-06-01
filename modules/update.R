# generic module to update a running bot by reinitiating main script  ####

# module.list <- unique(append(module.list, "update"))
cat("I was initalized \n")
update <- function(bot, update){
  err<<-NA; tryCatch(expr = {
    if (update$message$from$id == botmaster) {
      updater$stop_polling()
      bot$getUpdates(offset = update$update_id + 1)
      source(currentScript)

    }else{
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = "Not authorized!")
    }
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
  
}
update_handler <- CommandHandler("update", update)
