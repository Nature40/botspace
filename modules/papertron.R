module.list <- unique(append(module.list, "papertron"))
library(rcrossref)
reticulate::source_python("resources/python/getdoi.py")
cat("I was initalized \n")
papertron <- function(bot, update){
  err=NA; tryCatch(expr = {
    update<<- update
    if(any(unlist(lapply(update$message$entities, function(x) x$type =="url")))){
      chat <- update$effective_chat()$id
      for(i in 1:length(which(unlist(lapply(update$message$entities, function(x) x$type =="url"))))){
        url <- gsub("\n","",substr(update$message$text,update$message$entities[[i]]$offset,
                      update$message$entities[[i]]$offset+update$message$entities[[i]]$length))
        urls <<-url
        err1 <- NA
        tryCatch(expr = {doi <- main(url)},
                 error = function(e) {err1<<-e},silent = T)
        if(!is.na(err1)){
          bot$sendMessage(chat_id = update$message$chat_id,
                          text = paste("Couldn't find DOI on webpage. Writing URL to collection."))
          write(url, file=paste0("tmp_files/",chat,"/error_papertron.txt"),append = T)
          rm(err1)
          out <- data.frame(url = url, doi = NA, bibtex = NA)
          if(!file.exists(paste0("tmp_files/",chat,"/bib.yaml"))) {
            dir.create(paste0("tmp_files/",chat))
            yaml::write_yaml(out, file=paste0("tmp_files/",chat,"/bib.yaml"))
          }else{
            yaml::write_yaml(rbind(as.data.frame(yaml::read_yaml(paste0("tmp_files/",chat,"/bib.yaml"))),out), 
                             file=paste0("tmp_files/",chat,"/bib.yaml"))
          }
        }else{
          out <- data.frame(url = url, doi = doi, bibtex = rcrossref::cr_cn(dois=doi,format="bibtex"))
          if(!file.exists(paste0("tmp_files/",chat,"/bib.yaml"))) {
            dir.create(paste0("tmp_files/",chat))
            yaml::write_yaml(out, file=paste0("tmp_files/",chat,"/bib.yaml"))
          }else{
            yaml::write_yaml(rbind(as.data.frame(yaml::read_yaml(paste0("tmp_files/",chat,"/bib.yaml"))),out), 
                             file=paste0("tmp_files/",chat,"/bib.yaml"))
          }
          bot$sendMessage(chat_id = update$message$chat_id,
                          text = paste("Paper saved to collection."))
          
        }
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

collection <- function(bot, update){
  chat <- update$effective_chat()$id
  if(file.exists(paste0("tmp_files/",chat,"/bib.yaml"))){
    bot$send_document(chat_id = update$message$chat_id, 
                      document = paste0("tmp_files/",chat,"/bib.yaml"))
  }
}
papertron_handler <- MessageHandler(papertron)
collection_handler <- CommandHandler("collection", collection, username="PaperTron_bot")
