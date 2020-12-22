library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

df <- readRDS("C:/Users/hüseyin/Documents/GitHub/mef04g-bak-r-iz/ispark-parkbilgileri.RDS")




ui <- fluidPage(
  hr(),
  title = "ISPARK Report",
  tabsetPanel(
    tabPanel("Map", leafletOutput("map")),
    tabPanel("Graph", 
             column(6,plotOutput("plot2")),
             column(6,plotOutput("plot")))
  ),
  hr(),
  fluidRow(
    column(1),
    column(3, 
           
            checkboxInput("selectCar","Select Car", value = FALSE, width = NULL),
            textOutput("car")
    ),
    column(3,
           dateRangeInput("selectDate", "Select Date", start = NULL, end = NULL, min = NULL,
                          max = NULL, format = "yyyy-mm-dd", separator = " - ")
           
    ),
    column(3,
           selectInput("location","Park Location", c(df$Ilce), multiple = TRUE)
    ),
    column(3,
           sliderInput("park time",
                       "PArk Time",
                       min = 0,
                       max = 100,
                       value = 25,
                       step = 1,
                       ticks = FALSE,
                       sep="")),
  )
)

server <- function(input, output, session) {
  
  
  output$car <- renderText({ input$selectCar })
  
  }
  
  
  output$map <- renderLeaflet({
    df1 <- df %>% filter(!adi %in% input$stations) %>% filter(total > input$total) %>% filter(bos > input$bos)
    df1 %>%
      leaflet() %>% addTiles() %>%
      fitBounds(~min(df$lon), ~min(df$lat), ~max(df$lon), ~max(df$lat)) %>% 
      addMarkers(~lon, ~lat, popup = ~content)
  })
  
  output$plot <- renderPlot({
    df1 <- df %>% filter(!adi %in% input$stations) %>% filter(total > input$total)  %>% filter(bos > input$bos)
    ggplot(df1,aes(x=doluluk_orani, y=total))+
      geom_point(color="red")+
      labs(title="Capacity vs. Full-Rate",x ="Full Rate", y = "Capacity") +
      scale_x_continuous(limits = c(0,1)) +
      scale_y_continuous(limits = c(0,30)) +
      theme_light()
    
  })
  
  output$plot2 <- renderPlot({
    df1 <- df %>% filter(!adi %in% input$stations) %>% filter(total > input$total) %>% filter(bos > input$bos)
    ggplot(df1, aes(x=doluluk_orani))+
      geom_histogram(binwidth = 0.10, fill= "green")+
      labs(title="Full Rate Histogram",x ="Full Rate", y = "Count")+
      scale_x_continuous(limits = c(0,1)) +
      scale_y_continuous(limits = c(0,60)) +
      theme_light()
  })
}

shinyApp(ui, server)

