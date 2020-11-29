library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

isbike_20201118 <- readRDS("isbike_20201118.rds") %>% fromJSON()
df <- isbike_20201118$dataList %>% 
          filter(lon != 0) 

df$bos <- as.double(df$bos)
df$dolu <- as.double(df$dolu)
df$lat <- as.double(df$lat) 
df$lon <- as.double(df$lon) 

df <- df %>% mutate("total"=dolu+bos) %>%  transmute(istasyon_no, adi, lon, lat, bos, dolu, total, doluluk_orani = dolu / (bos+dolu))

ui <- fluidPage(
          hr(),
          title = "ISBIKE Report",
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
              selectInput("stations","Excluded Statitons", c(df$adi), multiple = TRUE)
              ),
            column(3,
              sliderInput("total",
                          "Total",
                          min = min(df$total),
                          max = max(df$total),
                          value = min(df$total),
                          step = 1,
                          ticks = FALSE,
                          sep="")),
            column(3,
                     sliderInput("bos", "Avaible Capacity", c(df$bos),
                                 min = min(df$bos),
                                 max = max(df$bos),
                                 value = min(df$bos),
                                 step = 1,
                                 ticks = FALSE))
            
          )
)


server <- function(input, output, session) {

  
  for (i in 1: 193) {
    content <- paste(sep = "<br/>",
                     str_c("<strong>",df$adi[i],"</strong>"),
                     paste0("Avaible Capacity: ", df$bos[i]),
                     paste0("Occupied Capacity: ", df$dolu[i])
    )
    df$content[i] <- content
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