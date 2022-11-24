library(ical)
library(calendar)

years <- as.character(2013:2019)

Bundesländer <- c("BW", "BY", "BE", "BB", "HB", "HH", "HE", "MV", "NI", "NW", "RP", "SL", "SN", "ST", "SH", "TH")

for (e in JahrMonat) {
  filename <- paste("G_IV_1-m",e,"_SH.xlsx", sep = "")
  url <- paste(
    "https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/", filename, sep = "")
  if (url.exists(url=url)) {
    filedest <- paste("sheets/", filename, sep = "")
    curl::curl_download(url, filedest)
    
    
    library(ical)
    library(calendar)
    
    
    https://www.feiertage-deutschland.de/content/kalender-download/force-download.php
    
    
    #ical
    ical_file <- system.file("Baden-Wuerttemberg_2014_Schulferien.ics", package = "ical")
    Feiertage <- ical_parse_df(ical_file)
    
    #calendar
    ics_file <- system.file("extdata", "ferien_bremen_2017.ics", package = "calendar")
    ics_df <- ic_dataframe(ics_file)
    
    
    ic_dataframe(x)
    
    a <- ic_dataframe(ical_example)
    
    ics_file <- system.file("extdata", "ferien_bremen_2017.ics", package = "calendar")
    x = readLines(ics_file)
    x_df = ic_dataframe(x)