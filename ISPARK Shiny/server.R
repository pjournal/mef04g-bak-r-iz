library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(dplyr)
library(ggplot2)

load("~/GitHub/mef04g-bak-r-iz/ISPARK Shiny/ISPARK.RData")
isparkparkbilgileri$Latitude <- as.numeric(isparkparkbilgileri$Latitude)
isparkparkbilgileri$Longitude <- as.numeric(isparkparkbilgileri$Longitude)

function(input, output, session){
  
  
  output$car <- renderText({ input$selectCar })
  
  
  
  
  output$map <- renderLeaflet({
    df1 <- isparkparkbilgileri  #%>% filter(Kapasitesi > input$total) %>% filter(bos > input$bos)
    leaflet(df1) %>% addTiles() %>%
      fitBounds(~min(df1$Longitude), ~min(df1$Latitude), ~max(df1$Longitude), ~max(df1$Latitude)) %>% 
      addMarkers(~Longitude, ~Latitude)
  })
  
  # output$plot <- renderPlot({
  #   df1 <- isparkparkbilgileri #%>% filter(!adi %in% input$stations) %>% filter(total > input$total)  %>% filter(bos > input$bos)
  #   ggplot(df1,aes(x=doluluk_orani, y=total))+
  #     geom_point(color="red")+
  #     labs(title="Capacity vs. Full-Rate",x ="Full Rate", y = "Capacity") +
  #     scale_x_continuous(limits = c(0,1)) +
  #     scale_y_continuous(limits = c(0,30)) +
  #     theme_light()
  #   
  # })
  # 
  # output$plot2 <- renderPlot({
  #   df1 <- isparkparkbilgileri %>% filter(!adi %in% input$stations) %>% filter(total > input$total) %>% filter(bos > input$bos)
  #   ggplot(df1, aes(x=doluluk_orani))+
  #     geom_histogram(binwidth = 0.10, fill= "green")+
  #     labs(title="Full Rate Histogram",x ="Full Rate", y = "Count")+
  #     scale_x_continuous(limits = c(0,1)) +
  #     scale_y_continuous(limits = c(0,60)) +
  #     theme_light()
  # })
}


