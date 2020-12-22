library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

ispark_data <- readRDS("C:/Users/hüseyin/Documents/GitHub/mef04g-bak-r-iz/ispark-parkbilgileri.RDS") %>% fromJSON()

