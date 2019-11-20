# generic module to update a running bot by reinitiating main script  ####

# module.list <- unique(append(module.list, "update"))
cat("I was initalized \n")
update <- function(bot, update){
  err<<-NA; tryCatch(expr = {
    if (update$message$from$id == botmaster) {
      updater$stop_polling()
      bot$getUpdates(offset = update$update_id + 1)
      source(currentScript)
      # for(i in module.list){
      #   source(paste0("modules/",i,".R"),local=F)
      #   cat("Updated module", i,"\n")
      # }
      
      # updater1 <- updater +update_handler+ start_handler+kill_handler+ping_handler+media_handler
      # updater1$start_polling(verbose=T)
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
