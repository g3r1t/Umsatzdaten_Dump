library(rvest)

webpage <- read_html(paste("http://www.seewetter-kiel.de/seewetter/daten_symbole.htm")) #read html page
weather_codes <- html_table(webpage, trim = TRUE)#turn all html-tables into a list of table-DFs
weather_codes <- weather_codes[[1]]# select first element of list of DFs

weather_codes <- weather_codes[-1]#drop first column

colnames(weather_codes)[1] <- "Wettercode"