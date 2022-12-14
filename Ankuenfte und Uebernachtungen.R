library(RCurl)
library(readxl)
library(readr)

#####################################################
# Import of overnight stay data
#The required data is available in the form of *.xlsx sheets at https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/G_IV_1-m1506_SH.xlsx 
#in this case for the month of June of the year 2015 indicated by "1506". In theory only this four digit code changes. For 78 of the 84 months
#that we are interested in, this statement is true. More about that later. The conclusion drawn from this means: First we need to create a vector
#containing all four digit "month-year-codes" for the desired months.

#Create vector of all month numbers in double digits
months <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
#create vector of all years of "umsatzdaten"
years <- as.character(13:19)


#create vector "JahrMonat" from vectors "months" and "years" containing all combinations of "years" and "months"
for (e in years)
  if (e == "13") {
    JahrMonat <- paste(e, months, sep = "")
  } else {
    a <- paste(e, months, sep = "")
    JahrMonat <- c(JahrMonat, a)
  }

#This for-loop iterates through every element of the vector "JahrMonat" pasting it into the URL. In every iteration it therefore downloads the
#next *.xlsx sheet. This statement is true for most of the sheets. Unfortunately for 7 of the 84 sheets the person overseeing the upload has
#made some typos and thereby almost made me loose my sanity bcs I had to figure out the exact typos made for each download error. So for 77 
#of the 84 #cases only the lines 91-95 and 116-122 are needed. Lines 96-115 are only needed to catch the typo-sheets ¯\_(ツ)_/¯

Uebernachtungen <- vector()
Ankuenfte <- vector()
for (e in JahrMonat) {
  filename <- paste("G_IV_1-m",e,"_SH.xlsx", sep = "")
  url <- paste(
    "https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/", filename, sep = "")
  if (url.exists(url=url)) {
    filedest <- paste("sheets/", filename, sep = "")
    curl::curl_download(url, filedest)
    xls <- read_excel(filedest, sheet = "T1_1")
    Uebernachtungen <- c(Uebernachtungen, xls[4][xls[1] == "02 Kiel"])
    Ankuenfte <- c(Ankuenfte, xls[2][xls[1] == "02 Kiel"])
  } else {
    filename <- paste("G_IV_1-m",e,"_SH-.xlsx", sep = "")
    url <- paste(
      "https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/", filename, sep="")
    if (!url.exists(url=url)) {
      filename <- paste("G_IV_1_m_S_",e,".xlsx", sep = "")
      url <- paste(
        "https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/", filename, sep = "")
      if (!url.exists(url=url)) {
        filename <- paste("G_IV_1_m",e,"_SH.xlsx", sep = "")
        url <- paste(
          "https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/", filename, sep = "")
      }
    }
    
    #declare file destination to be inside folder "sheets"
    filedest <- paste("sheets/", filename, sep = "")
    #download file from "url" into "filedest"
    curl::curl_download(url, filedest)
#import only sheet "T1_1" from file "filename" into variable xls
    xls <- read_excel(filedest, sheet = "T1_1")
#extract only overnight stays and arrivals for kiel from xls and concatenate it with the former vector "Uebernachtungen"
   Uebernachtungen <- c(Uebernachtungen, xls[4][xls[1] == "02 Kiel"])
   Ankuenfte <- c(Ankuenfte, xls[2][xls[1] == "02 Kiel"])
  }
}
#create common dataframe for "Uebernachtungen" and "JahrMonat"
Tourrerismus <- data.frame("Monatscode"=JahrMonat, "Uebernachtungen"=Uebernachtungen, "Ankuenfte" = Ankuenfte)
Tourrerismus$Uebernachtungen <- as.numeric(Tourrerismus$Uebernachtungen)
Tourrerismus$Ankuenfte <- as.numeric(Tourrerismus$Ankuenfte)
# Korrektur von Ankünften, weiß der Fuchs warum
Tourrerismus$Ankuenfte[Tourrerismus$Monatscode == 1905] <- 82098
Tourrerismus$Ankuenfte[Tourrerismus$Monatscode == 1504] <- 48844
Tourrerismus$Ankuenfte[Tourrerismus$Monatscode == 1610] <- 56974

Tourrerismus$Aufenthaltsdauer <- Tourrerismus$Uebernachtungen/Tourrerismus$Ankuenfte

write.csv(Tourrerismus,"Ankuenfte und Uebernachtungen.csv", row.names = FALSE)

####################################