module.list <- unique(append(module.list, "maintenance"))
cat("I was initalized \n")
active_polls <- list()
# args="test"
base_url <- paste0("https://api.telegram.org/bot",bot_token("Nat40_Fieldbot"))

bbx <- function(bot, update, args){
  err=NA; tryCatch(expr = {
    if(length(args)==0){
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = paste("You have to specify a site  \"/bbx <site> \""))
    }else{
      url <- sprintf("%s/sendPoll", base_url)
      
      data <- list(chat_id  = "-485748303",
                   #update$message$chat_id,
                   question = paste0("Wartung der Batteriebox an Standort:  ",args), 
                   options  = jsonlite::toJSON(readLines("resources/maintenance_01_solarpanel",
                                                         encoding="UTF-8")),
                   is_anonymous = FALSE,
                   type = "regular",
                   allows_multiple_answers = TRUE,
                   correct_option_id = NULL,
                   explanation = NULL,
                   explanation_parse_mode = NULL,
                   close_date = as.numeric(Sys.time()) + 120)
      
      res <- httr::POST(
        url = url,
        body = data,
        config = NULL,
        encode = "json"
      )
      res1 <- jsonlite::fromJSON(rawToChar(res$content))$result
      res1$site=args
      res1$from <- update$message$from
      
      if(length(active_polls)==0){
        active_polls <<- list(res1)
      }else{
        active_polls <<- rlist::list.append(active_polls,res1)
      }
    }
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
  
}

bbx_handler <- CommandHandler("bbx", bbx, pass_args = T)

check_poll <- function(bot, update){
  err=NA; tryCatch(expr = {
    update <- as.list(jsonlite::fromJSON(rawToChar(httr::POST(url = sprintf("%s/getUpdates", base_url), body= "",config=NULL,encode="json")$content))$result)
    
    if(!is.null(update$poll_answer)){
      updatex <<-update
      k <- unique(match(na.omit(update$poll$id),unlist(lapply(active_polls,function(x) x$poll$id))))
      k<<-k
      # k <- 1
      poll <- active_polls[[k]]
      
      poll$poll$options$voter_count <- update$poll_answer$option_ids%in%0:(length(poll$poll$options$voter_count)-1)
      yaml::write_yaml(poll,file=paste0("log/",poll$site, "_",poll$date,"_",poll$from$username,".yaml"))
      bot$sendMessage(chat_id = poll$chat$id,
                      text = paste("Thank's for voting on the Poll for Site",poll$site))
    }
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    
    bot$sendMessage(chat_id = "-485748303",
                    # update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
}

poll_handler <- PollHandler(check_poll)
