library(calendar)
library(readr)


Jahre <- as.character(2014:2019)#unfortunately data starts at 2014

Bundesländer <- c("Baden-Wuerttemberg","Bayern","Berlin","Brandenburg","Bremen", "Hamburg",
                  "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen", "Nordrhein-Westfalen",
                  "Rheinland-Pfalz", "Saarland","Sachsen","Sachsen-Anhalt", "Schleswig-Holstein", 
                  "Thueringen")

#create dataframe with the right dimensions for the rbind later on
ferien <- data.frame(seq(as.Date("2013/1/1"), as.Date("2019/12/31"), by="day"))
colnames(ferien) <- "Datum"

dir.create("icals_ferien")

for (b in Bundesländer){
  for (j in Jahre){
b <- "Saarland"
j <- "2015"
    filename <- paste("ferien_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/ferien/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_feiertage/", filename, sep = "")
    curl::curl_download(url, filedest)
    ical <- readLines(filedest)
    ics <- ic_dataframe(ical)
    colnames(ics)[3] <- "Beginn"
    colnames(ics)[4] <- "Ende"
    colnames(dfj)[6] <- "Ferienart"
    dfd <- data.frame(matrix(ncol = 1, nrow = 0))
    for (e in as.numeric(row.names(dfj))) {
    dfd <- rbind(dfd, data.frame(seq(as.Date(dfj$Beginn[e]), as.Date(dfj$Ende[e]), by="day")))
    dfd$Ferienart <- dfj$Ferienart[e]
    }
}
}


for (b in Bundesländer) {
  dfb <- data.frame(matrix(ncol = 3, nrow = 0))
  colnames(dfb) <- c("Beginn","Ende", b)
  for (j in Jahre) {
    filename <- paste("ferien_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/ferien/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_feiertage/", filename, sep = "")
    curl::curl_download(url, filedest)
    ical <- readLines(filedest)
    dfj <- ic_dataframe(ical)
    dfj[[b]] <- 1
    colnames(dfj)[3] <- "Datum"
    dfj <- dfj[,-c(1,2,4,5,6)]#drop redundant columns
    dfb <- rbind(dfb, dfj)
  }
  feiertage <- left_join(ferien, dfb, by = "Datum")
}
