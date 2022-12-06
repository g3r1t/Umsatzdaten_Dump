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
  dfb <- data.frame(matrix(ncol = 1, nrow = 0))
  for (j in Jahre){
    filename <- paste("ferien_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/ferien/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_feiertage/", filename, sep = "")
    curl::curl_download(url, filedest)
    ical <- readLines(filedest)
    ics <- ic_dataframe(ical)
    colnames(ics)[3] <- "Beginn"
    colnames(ics)[4] <- "Ende"
    #colnames(ics)[6] <- "Ferienart"
    dfj <- data.frame(matrix(ncol = 1, nrow = 0))
    for (e in as.numeric(row.names(ics))) {
      dfj <- rbind(dfj, data.frame(seq(as.Date(ics$Beginn[e]), as.Date(ics$Ende[e]), by="day")))
      #dfd$Ferienart <- ics$Ferienart[e]
    }
    dfb <- rbind(dfb, dfj)
  }
  dfb[[b]] <- 1
  colnames(dfb)[1] <- "Datum"
  ferien <- left_join(ferien, dfb, by = "Datum")
}

Ferientage_2013 <- read_delim("https://raw.githubusercontent.com/g3r1t/Umsatzdaten_Dump/main/Ferientage_2013.csv", 
                              delim = ";", escape_double = FALSE, trim_ws = TRUE, show_col_types = FALSE)

colnames(Ferientage_2013)[1] <- "Datum"

Ferientage_2013$Datum <- as.Date(Ferientage_2013$Datum, "%d.%m.%Y")

ferien <- rbind(ferien, Ferientage_2013)

ferien <- ferien[rowSums(is.na(ferien)) != 16,]

ferien[is.na(ferien)] <- 0

write.csv(ferien,"Ferien.csv", row.names = FALSE)