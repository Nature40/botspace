module.list <- unique(append(module.list, "maintenance"))
cat("I was initalized \n")
base_url <- paste0("https://api.telegram.org/bot",bot_token("Nat40_Fieldbot"))

bbx <- function(bot, update, args){
  err=NA; tryCatch(expr = {
    
    
    
    url <- sprintf("%s/sendPoll", base_url)
    
    
    data <- list(chat_id=update$message$chat_id,#"-361124846",
                 question = paste("Wartung der Batteriebox an Standort",args,":"), 
                 options = jsonlite::toJSON(readLines("resources/maintenance_bbx")),
                 is_anonymous = FALSE,
                 type = "regular",
                 allows_multiple_answers = TRUE,
                 correct_option_id = NULL,
                 explanation = NULL,
                 explanation_parse_mode = NULL,
                 close_date = as.numeric(Sys.time()) + 200)
    
    res <- httr::POST(
      url = url,
      body = data,
      config = NULL,
      encode = "json"
    )
    
    res1 <- jsonlite::fromJSON(rawToChar(res$content))
    
    
    poll_id <- res1$result$poll$id
    # str(res)
    # update <- jsonlite::fromJSON(sprintf("%s/getUpdates", base_url))
    # result$poll$question
    
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
  
}
maintenance_handler <- CommandHandler("bbx", bbx, pass_args = T)