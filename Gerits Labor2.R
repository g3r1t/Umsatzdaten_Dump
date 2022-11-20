library(readxl)

url <- "https://www.statistik-nord.de/fileadmin/Dokumente/Statistische_Berichte/industrie__handel_und_dienstl/G_IV_1_m_S/G_IV_1-m1704_SH.xlsx"
destfile <- "G_IV_1_m1704_SH.xlsx"
curl::curl_download(url, destfile)
G_IV_1_m1704_SH <- read_excel(destfile, sheet = "T1_1")