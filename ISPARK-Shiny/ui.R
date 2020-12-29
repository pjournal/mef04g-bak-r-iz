library(tidyverse)
library(shiny)
library(htmltools)
library(leaflet)



navbarPage("ISPARK Analysis", # Sayfa Basligi ve Baslangici
  tabPanel("Map",             #Ä°kinci sayfa baslangici ve basligi
    div(class="outer",
        tags$head(
          includeCSS("styles.css")
        ),
        
        leafletOutput("map", width="100%", height="100%"),
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                      draggable = TRUE, top = "auto", left = 40, right = "auto", bottom = 80,
                      width = 330, height = 330,
                      
                      h2("Filters"),
                      sliderInput("total", "Total Capacity of Park", min(isparkparkbilgileri$Kapasitesi), max(isparkparkbilgileri$Kapasitesi),
                                  value = c(0,5000), step = 5, ticks = FALSE),
                      sliderInput("occupancyrate", "Select Occupancy Rate", 
                                  min(isparkparkbilgileri$OrtalamaDoluluk), 
                                  max(isparkparkbilgileri$OrtalamaDoluluk), 
                                  value = c(0,100),
                                  ticks = FALSE),
                      selectInput("district", "Select District", c("All",unique(isparkparkbilgileri$Ilce)),selected = "All")
        )
    )
  ),          
  tabPanel("Plots",           # Ilk sayfanÄ±n adı ve baslangici
    sidebarLayout(            # Sol tarafta secenek sag tarafta plot olacak ÅŸekilde tasarÄ±m
      sidebarPanel(width = 3,
                   
                   selectInput("x","District",c("Please Select a District",unique(isparkparkbilgileri$Ilce))),
                   selectInput("y","Park Area Name",c("Please Select a Park Area",unique(isparkparkbilgileri$ParkAdi)))
                   
                   # selectInput("location","Park Location", c(isparkparkbilgileri$Ilce), multiple = FALSE),
                   # selectInput("parkType", "Select Park type", c(isparkparkbilgileri$ParkTipi), multiple = FALSE),
                   # silederInput(inputId = "timeRange",
                   # "Time Range",
                   # min = min(parkcapacitylog$OlcumZaman???),
                   # max = max(parkcapacitylog$OlcumZaman???),
                   # value = c(2019,2020),
                   # step=1)),
                   
            
        ),
      mainPanel(width = 9,
                plotOutput("plot5", height = "600px")
                
                
      )
    )
  )
)