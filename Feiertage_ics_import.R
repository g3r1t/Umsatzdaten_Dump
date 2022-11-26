library(calendar)

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
