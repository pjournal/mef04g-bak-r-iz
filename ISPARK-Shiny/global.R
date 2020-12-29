library(dplyr)

githubURL <- "https://github.com/pjournal/mef04g-bak-r-iz/raw/gh-pages/ISPARK-Shiny/ISPARK.RData"
download.file(githubURL,"ISPARK.Rdata")
load("ISPARK.Rdata")

isparkparkbilgileri$Latitude <- as.numeric(isparkparkbilgileri$Latitude)
isparkparkbilgileri$Longitude <- as.numeric(isparkparkbilgileri$Longitude)
ortdol <- function(ID){
  df <- parkcapacitylog %>% filter(ParkID == ID)
  mean(df$DolulukYuzdesi) %>% round(., digits = 2)
}
isparkparkbilgileri <- isparkparkbilgileri %>% mutate(OrtalamaDoluluk=ortdol(ParkID))
isparkparkbilgileri$popup <- NA
for (i in 1:nrow(isparkparkbilgileri)) {
  content <- paste(sep = "<br/>",
                   paste0("<b>", isparkparkbilgileri$ParkAdi[i],"</b>"),
                   paste0("District: ",isparkparkbilgileri$Ilce[i]),
                   paste0("Park Area Capacity: ", isparkparkbilgileri$Kapasitesi[i]),
                   paste0("Average Occupancy Rate: %", (100-isparkparkbilgileri$OrtalamaDoluluk[i]))
  )
  isparkparkbilgileri$popup[i] <- content
}
