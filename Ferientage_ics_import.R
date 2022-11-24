library(calendar)

Jahre <- as.character(2014:2019)#unfortunately data starts at 2014

Bundesländer <- c("Baden-Wuerttemberg","Bayern","Berlin","Brandenburg","Bremen", "Hamburg",
                "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen", "Nordrhein-Westfalen",
                "Rheinland-Pfalz", "Saarland", "Schleswig-Holstein", "Thueringen")

#create dataframe with the right dimensions for the rbind later on
ferien <- data.frame(matrix(ncol = 7, nrow = 0))

#rename column names in order to be able to "rbind"
colnames(ferien) <- c("DTSTAMP", "UID", "DTSTART;VALUE=DATE", "DTEND;VALUE=DATE", "DESCRIPTION", 
                      "SUMMARY", "Bundesland")

dir.create("icals_ferien")

for (b in Bundesländer) {
  for (j in Jahre) {
    filename <- paste("Ferien_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/ferien/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_ferien/", filename, sep = "")
    curl::curl_download(url, filedest)
    ical <- readLines(filedest)
    df <- ic_dataframe(ical)
    df$Bundesland <- b
    ferien <- rbind(ferien, df)
  }
}

ferien <- ferien[,-c(1,2,5)]#drop redundant columns
colnames(ferien) <- c("Anfang", "Ende", "Feiertag", "Bundesland")
ferien$Anfang <- as.Date(ferien$Anfang)
ferien$Ende <- as.Date(ferien$Ende)