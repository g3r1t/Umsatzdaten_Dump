library(rvest)
library(stringr)
library(data.table)
library(dplyr)



years <- (2013:2019)# create vector for all years

ferien <- data.frame(matrix(ncol = 8, nrow = 0))# create empty data frame with the dimensions needed to "rbind"

#rename column names according to data from "schulferien.org" in order to be able to "rbind"
colnames(ferien) <- c("Bundesländer", "Winterferien", "Osterferien", "Pfingstferien", "Sommerferien",
       "Herbstferien", "Weihnachtsferien", "Jahr")

for (e in years){
  webpage <- read_html(paste("https://www.schulferien.org/deutschland/ferien/", e,"/", sep="")) #read html page
  df <- html_table(webpage, trim = TRUE)#turn all html-tables into a list of table-DFs
  df <- df[[1]]# select first element of list of DFs
  colnames(df) <- unlist(df[1,]) #2nd row as column names
  colnames(df)[1] <- "Bundesländer"#after import 1st column is literally nameless "". Now named and baptized!!!
  df = df[-1, ] #drop 2nd row
  df$Jahr <- rep(e, 16) #create column Jahr as an identifier for the 16 "Bundesländer"
  ferien <- rbind(ferien, df)#append df to ferien
}

ferien[] <- lapply(ferien, gsub, pattern = "*", replacement = "", fixed = TRUE)#trim *-chars
ferien[] <- lapply(ferien, gsub, pattern = " ", replacement = "", fixed = TRUE)#trim spaces

Ferienarten <- c("Winterferien", "Osterferien", "Pfingstferien", "Sommerferien", "Herbstferien", "Weihnachtsferien") 
bool <- as.logical(rep(0, each=112))

for (f in Ferienarten){
  b <- str_detect(ferien[[f]], fixed('.+'))
  bool <- bool + b
}

bool[bool > 1] <- 1
bool <- as.logical(bool)
Handarbeit <- filter(ferien, bool)
write.csv(Handarbeit)
ferien <- ferien[-c(which(TRUE == bool)),]

