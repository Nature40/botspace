# generic module to deal with unknown commands ####

module.list <- unique(append(module.list, "unknown"))
cat("I was initalized \n")
unknown <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Sorry, I didn't understand that command.")
}

unknown_handler <-  MessageHandler(unknown, MessageFilters$command)