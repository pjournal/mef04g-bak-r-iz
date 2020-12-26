library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(dplyr)
library(ggplot2)


function(input, output, session){
  
  output$car <- renderText({ input$selectCar })
  
  colorpal <- reactive({
    colorNumeric("RdYlGn", isparkparkbilgileri$OrtalamaDoluluk)
  })
  
  datafilt <- reactive({
    df1 <- isparkparkbilgileri  %>% filter(Kapasitesi >= input$total[1], Kapasitesi <= input$total[2])
  })
  
  output$map <- renderLeaflet({
    df1 <- datafilt() #%>% filter(!adi %in% input$stations)
    leaflet(df1) %>% addTiles() %>%
      fitBounds(~min(df1$Longitude), ~min(df1$Latitude), ~max(df1$Longitude), ~max(df1$Latitude))
      #addMarkers(~Longitude, ~Latitude)
      #addCircles(~Longitude, ~Latitude, radius=df1$Kapaiste,
      #           stroke=FALSE, fillOpacity=0.4, fillColor="Green")
  })
  
  observe({
    pal <- colorpal()
    df1 <- datafilt()
    leafletProxy("map", data = df1) %>%
      clearShapes() %>%
      addCircles(radius = ~df1$Kapasitesi, layerId= ~df1$ParkID, popup = ~popup, weight = 1, color = "#777777",
                 fillColor = ~pal(df1$OrtalamaDoluluk), fillOpacity = 0.5, stroke = FALSE
      )
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


