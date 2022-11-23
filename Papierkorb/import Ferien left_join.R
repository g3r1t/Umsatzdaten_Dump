library(rvest)
library(tidyverse)
library(dplyr)


ferien <- data.frame(c("Baden-Württemberg", "Bayern", "Berlin", "Brandenburg", "Bremen", "Hamburg", 
                      "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen", "Nordrhein-Westfalen", 
                      "Rheinland-Pfalz", "Saarland", "Sachsen", "Sachsen-Anhalt", "Schleswig-Holstein", 
                      "Thüringen"))

colnames(ferien)[1] <- "Bundesländer"

years <- as.character(c(13:19))

for (e in years){
  webpage <- read_html(paste("https://www.schulferien.org/deutschland/ferien/20", e,"/", sep="")) #read html page
  df <- html_table(webpage, trim = TRUE)#turn html table into DF
  df <- df[[1]]
  colnames(df) <- as.character(unlist(df[1,])) #2nd row as column names
  colnames(df)[1] <- "Bundesländer"
  df = df[-1, ] #drop 2nd row
  df[] <- lapply(df, gsub, pattern = "*", replacement = "", fixed = TRUE)#trim *-chars
  df[] <- lapply(df, gsub, pattern = " ", replacement = "", fixed = TRUE)#trim spaces
  ferien <- left_join(ferien, df, by="Bundesländer", suffix(x, y))
}

