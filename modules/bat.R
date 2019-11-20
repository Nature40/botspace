# bat module for querying the MySQL database of the radiotracking stations ####
# Test module ####

module.list <- unique(append(module.list, "bat")) # needed for update-module

cat("I was initalized \n")
dbname <- "rteu"
results <- NA
# Batmans helper functions ####
library(RMySQL)
build_latest_signals_query <- function(strength,freq_error,freq, limit, hours)  {
  
  timest<-Sys.time()-2*hours*3600
  timest<-str_sub(timest, start=1, end=19)
  and <- "AND"
  where<-"WHERE "
  query_max_signal_filter<-paste(and,"max_signal >=",strength[1],"AND max_signal <=",strength[2])
  error <- freq_error * 1000
  inner_join <- " INNER JOIN `runs` r ON s.run = r.id "
  query_freq_filter<-paste0("((signal_freq + center_freq + ",error,") >", freq*1000, "  AND (signal_freq + center_freq - ",error,")  <", freq*1000)
  query_freq_filter<-paste0(query_freq_filter,") ")
  
  
  quer<-paste0("SELECT device, timestamp, duration, signal_freq, center_freq, run, max_signal, signal_bw FROM `signals` s", inner_join, where,query_freq_filter,query_max_signal_filter," AND timestamp>=","'", timest,"'", " ORDER BY s.id DESC LIMIT ", limit,";")
  
  
}
signal_data<-function(mysql_data){
  
  #tmp<-subset(get_mysql_data(),signal_freq!=0)
  mysql_data$timestamp <- as.POSIXct(mysql_data$timestamp,tz="UTC")
  mysql_data$signal_freq <- round((mysql_data$signal_freq+mysql_data$center_freq)/1000)
  mysql_data$receiver <- substr(mysql_data$device, start = 1, stop = 24)
  return(mysql_data)
}

# The real function #### 

bat <- function(bot, update, args){
  
  err=NA; tryCatch(expr = {
    bot$getUpdates(offset = update$update_id + 1)
    args <- paste(args)
    if(is.null(args) | length(args)!=2){
      bot$sendMessage(chat_id = update$message$chat_id,
                      text = "Please tell me the frequency of the tag and a timeframe
                    e.g.: ´/bat 150.020 2´ to check the last two hours for the frequence 150.020 MHz ")
    }else{
      freq <- as.numeric(gsub("[.]","",args[1]))
      hours <- try(as.numeric(args[2]))
      if(!nchar(freq)==6 & is.numeric(freq)){
        bot$sendMessage(chat_id = update$message$chat_id,
                        text = "Wrong frequency. Please insert something like ´150020´ or ´150.020´ ")
      } else if (!nchar(hours)<=2 & !is.numeric(hours)|is.na(hours)){
        bot$sendMessage(chat_id = update$message$chat_id,
                        text = "Wrong timeframe. Please insert something like ´2´ or ´5´ to get two or five hours.")
      } else{
        bot$sendMessage(chat_id = update$message$chat_id,
                        text = "Trying to connect to database...")
        
        if(is.na(pingr::ping_port("82.165.98.48", port = "10198", timeout = 4, count = 1))){
          bot$sendMessage(chat_id = update$message$chat_id,
                          text = "Cannot connect to database..")
        }else{
          con = NA;tryCatch(con<-dbConnect(
            RMySQL::MySQL(),
            dbname = dbname,
            host = Sys.getenv(paste0(dbname,"_host")),
            port = as.integer(Sys.getenv(paste0(dbname,"_port"))),
            username = Sys.getenv(paste0(dbname,"_username")),
            password = Sys.getenv(paste0(dbname,"_password"))),
            error = function(e) {
              out<<- e},
            silent = T)
          if(is.na(con)){
            bot$sendMessage(chat_id = update$message$chat_id,
                            text = "... failed!")
            bot$sendMessage(chat_id = update$message$chat_id,
                            text = gsub("<simple", "", out))
            
            rm(list= c("con","out"))
          }else{
            bot$sendMessage(chat_id = update$message$chat_id,
                            text = "... connected!")
            limit<-100
            bot$sendMessage(chat_id = update$message$chat_id,
                            text = "starting query..")
            bot$sendChatAction(
              chat_id = update$message$chat_id,
              action = "typing"
            )
            quer<-build_latest_signals_query(freq=freq, freq_error = 2, limit=limit, strength=c(0,100), hours = hours)
            bot$sendChatAction(
              chat_id = update$message$chat_id,
              action = "typing"
            )
            quer_results<-dbGetQuery(con, quer)
            quer_results<<-results
            signals<-signal_data(quer_results)
            
            signals$device<-str_sub(signals$device, start=1, end=16)
            
            ggplot(data=signals, mapping=aes(x=timestamp, y=max_signal, color=device))+geom_point()+theme_classic()  +
              theme(legend.position = "top")
            ggsave("tmp/batman_tmp.png", width = 5, height = 5)
            
            if(mean(signals$max_signal, na.rm=TRUE)>=85){
              out <- "OOOH! The bat is sitting on your Antenna. You better go searching!"
            }
            
            if(mean(signals$max_signal, na.rm=TRUE)>=75 & mean(signals$max_signal, na.rm=TRUE)<=85){
              out <- "OOOH! The bat is sitting next to your Antenna. You better go searching!"
            }
            
            if(mean(signals$max_signal, na.rm=TRUE)>=60 & mean(signals$max_signal, na.rm=TRUE)<=75){
              out <- "The bat near by your Antenna. You better go searching!"
            }
            
            if(mean(signals$max_signal, na.rm=TRUE)>=50 & mean(signals$max_signal, na.rm=TRUE)<=60){
              out <- "The bat is in reach of your Antenna. You better go searching!"
            }
            
            if(mean(signals$max_signal, na.rm=TRUE)<=50){
              out <- "There is no bat. You can stay at home!"}
            
            if(nrow(signals)<= 0.5 * limit){
              out <- "There is no bat. You can stay at home!"}
            
            dbDisconnect(con)
            
            bot$sendPhoto(
              chat_id = update$message$chat_id,
              photo = "tmp/batman_tmp.png",
              caption = sprintf(out))
          }
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
bat_handler <- CommandHandler("bat", bat, pass_args=T)



