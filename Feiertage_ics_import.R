library(calendar)
library(dplyr)
library(readr)

Jahre <- as.character(2014:2019)#unfortunately data starts at 2014

Bundesländer <- c("Baden-Wuerttemberg","Bayern","Berlin","Brandenburg","Bremen", "Hamburg",
                  "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen", "Nordrhein-Westfalen",
                  "Rheinland-Pfalz", "Saarland","Sachsen","Sachsen-Anhalt", "Schleswig-Holstein", 
                  "Thueringen")

#create dataframe with the right dimensions for the rbind later on
feiertage <- data.frame(seq(as.Date("2013/1/1"), as.Date("2019/12/31"), by="day"))
colnames(feiertage) <- "Datum"

dir.create("icals_feiertage")

for (b in Bundesländer) {
  dfb <- data.frame(matrix(ncol = 2, nrow = 0))
  colnames(dfb) <- c("Datum", b)
  for (j in Jahre) {
    filename <- paste("Feiertage_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/feiertage/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_feiertage/", filename, sep = "")
    curl::curl_download(url, filedest)
    ical <- readLines(filedest)
    dfj <- ic_dataframe(ical)
    dfj[[b]] <- 1
    colnames(dfj)[3] <- "Datum"
    dfj <- dfj[,-c(1,2,4,5,6)]#drop redundant columns
    dfb <- rbind(dfb, dfj)
  }
  feiertage <- left_join(feiertage, dfb, by = "Datum")
}

#Import manually added data for 2013
feiertage2013 <- read_delim("https://raw.githubusercontent.com/g3r1t/Umsatzdaten_Dump/main/Feiertage_2013.csv", 
                             delim = ";", escape_double = FALSE, trim_ws = TRUE,show_col_types = FALSE)

feiertage2013$Datum <- as.Date(feiertage2013$Datum, "%d.%m.%Y")

feiertage2013 <- feiertage2013[,-c(1,3)]

feiertage2013 <- feiertage2013[c("Datum", Bundesländer)]

feiertage <- rbind(feiertage, feiertage2013)

feiertage <- feiertage[rowSums(is.na(feiertage)) != 16,]

feiertage[is.na(feiertage)] <- 0

write.csv(feiertage,"Feiertage.csv", row.names = FALSE)