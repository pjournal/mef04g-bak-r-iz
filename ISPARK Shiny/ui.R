library(tidyverse)
library(shiny)

navbarPage("ISPARK Analysis", # Sayfa Basligi ve Baslangici
          tabPanel("Plots",           # Ilk sayfanın adı ve baslangici
            sidebarLayout(            # Sol tarafta secenek sag tarafta plot olacak şekilde tasarım
              sidebarPanel(width = 3,
                #dateRangeInput("selectDate", "Select Date", start = NULL, end = NULL, min = NULL,
                #               max = NULL, format = "yyyy-mm-dd", separator = " - "),
                #checkboxInput("selectCar","Select Car", value = FALSE, width = NULL),
                #selectInput("location","Park Location", c(df$Ilce), multiple = TRUE)
                
              ),
              mainPanel(width = 9
                          # Buraya grafik eklenecek
              )
            )
         ),
         tabPanel("Map",             #İkinci sayfa baslangici ve basligi
            sidebarLayout(            # Sol tarafta secenek sag tarafta plot olacak şekilde tasarım
              sidebarPanel(width = 3
              ),
              mainPanel(width = 9,
                        leafletOutput("map", height = 900)
              )
            )              
         )
)