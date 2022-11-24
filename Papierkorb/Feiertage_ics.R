library(ical)
library(calendar)

Jahre <- as.character(2014:2019)#unfortunately data starts at 2014

Bundesländer <- c("Baden-Wuerttemberg","Bayern","Berlin","Brandenburg","Bremen", "Hamburg",
                "Hessen", "Mecklenburg-Vorpommern", "Niedersachsen", "Nordrhein-Westfalen",
                "Rheinland-Pfalz", "Saarland", "Schleswig-Holstein", "Thueringen")




for (b in Bundesländer) {
  for (j in Jahre) {
    filename <- paste("Ferien_",b,"_",j , sep = "")
    url <- paste(
      "https://www.ferienwiki.de/exports/ferien/",j ,"/de/",b, sep = "")
    filedest <- paste("icals_ferien/", filename, sep = "")
    curl::curl_download(url, filedest)
  }
}


x <- readLines("ferien_baden-wuerttemberg_2014.ics")
df <- ic_dataframe(x)