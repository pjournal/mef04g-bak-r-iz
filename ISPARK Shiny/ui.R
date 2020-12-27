library(tidyverse)
library(shiny)
library(htmltools)
library(leaflet)



navbarPage("ISPARK Analysis", # Sayfa Basligi ve Baslangici
  tabPanel("Map",             #İkinci sayfa baslangici ve basligi
    # sidebarLayout(            # Sol tarafta secenek sag tarafta plot olacak şekilde tasarım
    #   sidebarPanel(width = 3
    #   ),
    #   mainPanel(width = 9,
    #     leafletOutput("map")
    #   )
    # )
    div(class="outer",
        tags$head(
          includeCSS("styles.css")
        ),
        
        leafletOutput("map", width="100%", height="100%"),
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                      draggable = TRUE, top = "auto", left = 40, right = "auto", bottom = 80,
                      width = 330, height = "auto",
                      
                      h2("Filters"),
                      sliderInput("total", "Total Capacity of Park", min(isparkparkbilgileri$Kapasitesi), max(isparkparkbilgileri$Kapasitesi),
                                  value = c(0,5000), step = 5, ticks = FALSE),
                      checkboxInput("legend", "Show legend", TRUE)
        )
    )
  ),          
  tabPanel("Plots",           # Ilk sayfanın adı ve baslangici
    sidebarLayout(            # Sol tarafta secenek sag tarafta plot olacak şekilde tasarım
      sidebarPanel(width = 3,
                   # selectInput("location","Park Location", c(isparkparkbilgileri$Ilce), multiple = TRUE),
                   # silederInput(inputId = "timeRange",
                   # "Time Range",
                   # min = min(parkcapacitylog$OlcumZaman???),
                   # max = max(parkcapacitylog$OlcumZaman???),
                   # value = c(2019,2020),
                   # step=1)),
                   
            
        ),
      mainPanel(width = 9
                # output$plot <- renderPlot({
                #   df <- isparkparkbilgileri %>% filter(OlcumZaman??? %in% input$timeRange) %>% filter(Ilce %in% input$location)
                #   ggplot(df,aes(x=OlcumZaman???, y=DolulukYuzdesi))+
                #     geom_line()
                
      )
    )
  )
)