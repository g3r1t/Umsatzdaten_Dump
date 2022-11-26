library(calendar)
library(dplyr)

Jahre <- as.character(2014:2019)#unfortunately data starts at 2014

Bundesländer <- c("Baden-Wuerttemberg","Bayern","Berlin","Brandenburg","Bremen", "Hamburg",
                  "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen", "Nordrhein-Westfalen",
                  "Rheinland-Pfalz", "Saarland","Sachsen","Sachsen-Anhalt", "Schleswig-Holstein", 
                  "Thueringen")

#create dataframe with the right dimensions for the rbind later on
feiertage <- data.frame(matrix(ncol = 7, nrow = 0))

#rename column names in order to be able to "rbind"
colnames(feiertage) <- c("DTSTAMP", "UID", "DTSTART;VALUE=DATE", "DTEND;VALUE=DATE", "DESCRIPTION", 
                      "SUMMARY", "Bundesland")

dir.create("icals_feiertage")

for (b in Bundesländer) {
  for (j in Jahre) {
    filename <- paste("Feiertage_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/feiertage/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_feiertage/", filename, sep = "")
    curl::curl_download(url, filedest)
    ical <- readLines(filedest)
    df <- ic_dataframe(ical)
    df$Bundesland <- b
    feiertage <- rbind(feiertage, df)
  }
}

feiertage <- feiertage[,-c(1,2,4,5)]#drop redundant columns
colnames(feiertage) <- c("Datum", "Feiertag", "Bundesland")
feiertage$Datum <- as.Date(feiertage$Datum)

#Import manually added data for 2013
feiertage2013 <- read_delim("https://raw.githubusercontent.com/g3r1t/Umsatzdaten_Dump/main/Feiertage_2013.csv", 
                             delim = ";", escape_double = FALSE, trim_ws = TRUE,show_col_types = FALSE)

feiertage2013$Datum <- as.Date(feiertage2013$Datum, "%d.%m.%Y")
feiertage2013[is.na(feiertage2013)] <- 0

Extrawürste <- colnames(feiertage2013[,c(5:15)])

for (b in Bundesländer){
  if (b %in% Extrawürste){
    df <- filter(feiertage2013, Alle == 1 | feiertage2013[[b]])
    df$Bundesland <- b
    df <- select(df, Datum, Feiertag, Bundesland)
    rbind(feiertage, df)
  }
  else {
    df <- filter(feiertage2013, Alle == 1)
    df$Bundesland <- b
    df <- select(df, Datum, Feiertag, Bundesland)
    rbind(feiertage, df)
  }
}

#write.csv(feiertage,"Feiertage.csv", row.names = FALSE)