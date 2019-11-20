# generic module to stop a bot ####

module.list <- unique(append(module.list, "kill")) # needed for update-module
cat("I was initalized \n")
kill <- function(bot, update) {
  err=NA; tryCatch(expr = {
    if (update$message$from$id == botmaster) { # only botmaster can kill
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = "Stop polling!")
      bot$getUpdates(offset = update$update_id + 1)
      updater$stop_polling();bot$getUpdates(offset = update$update_id + 1)
    } else{
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = "Permission denied!")
    }
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
}
kill_handler <- CommandHandler("kill", kill)