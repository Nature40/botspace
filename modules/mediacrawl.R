module.list <- unique(append(module.list, "mediacrawl")) # needed for update-module

cat("I was initalized \n")

media <- function(bot, update) {
  err=NA; tryCatch(expr = {
    name =  paste(update$message$from$first_name,update$message$from$id, sep="_")
    cat(paste0(name," at ",Sys.time(),"\n"))
    pic <- update$message$photo
    if(!dir.exists("Media")) dir.create("Media")
    if(!dir.exists("Media/pics")) dir.create("Media/pics")
    if(!dir.exists("Media/vids")) dir.create("Media/vids")
    picdir <- "Media/pics/"
    viddir <- "Media/vids/"
    
    if ("photo" %in% names(update$message)) {
      write.table(data.frame(user = name,
                             task = "photo",
                             timestamp = Sys.time()), file="Media/usr_data.csv", sep=";",dec=".",row.names=F,col.names = F,append =T)
      
      # check whether message contains foto
      if(!dir.exists(paste0(picdir,name))){
        dir.create(paste0(picdir,name))
      }
      
      updater$bot$get_file(file_id = as.character(update$message$photo[[length(pic)]]$file_id),
                           destfile = gsub(":","_",paste0(picdir,name,"/",
                                                          update$message$from$first_name,"_",
                                                          format(Sys.time(),"%d_%m_%X"),".jpg"))) # save the foto
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = sprintf("nomnomnom"))
    }
    
    if ("video" %in% names(update$message)) {
      write.table(data.frame(user = name,
                             task = "video",
                             timestamp = Sys.time()), 
                  file="Media/usr_data.csv", sep=";",dec=".",row.names=F,col.names = F,append =T)
      
      # check whether message contains foto
      if(!dir.exists(paste0(viddir,name))){
        dir.create(paste0(viddir,name))
      }
      # updater$bot$get_file(file_id = as.character(update$message$video$file_id),
      #                      destfile = gsub(":","_",paste0("vids/",update$message$from$first_name,"_",
      #                                                     format(Sys.time(),"%d_%m_%X"),".mp4"))) # save the foto
      updater$bot$get_file(file_id = as.character(update$message$video$file_id),
                           destfile = gsub(":","_",paste0(viddir,name,"/",
                                                          update$message$from$first_name,"_",
                                                          format(Sys.time(),"%d_%m_%X"),".mp4")))
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = sprintf("nomnomnom"))
      
    }
  },
  error = function(e) {err<<-e},silent = T)
  if(!is.na(err)){
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste("An error occurred \n",gsub("<simple", "", err),
                                 "\n You should contact the bot master. \n"))
  }
  
}

media_handler <- MessageHandler(media) 