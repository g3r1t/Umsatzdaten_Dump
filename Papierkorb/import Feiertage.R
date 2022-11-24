library(rvest)

feiertage <- data.frame(matrix(ncol = 5, nrow = 0))

years <- (2013:2019)# create vector for all years

for (e in years){
  webpage <- read_html(paste("https://www.schulferien.org/deutschland/feiertage/", e,"/", sep="")) #read html page
  df <- html_table(webpage, trim = TRUE)#turn all html-tables into a list of table-DFs
  df <- df[[1]]# select first element of list of DFs
  feiertage <- rbind(feiertage, df)#append df to feiertage
}

feiertage <- feiertage[-4]#drop 4th column