library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(dplyr)
library(ggplot2)


function(input, output, session){
  
  
  
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

  observeEvent(input$x,{
    if(input$x=="_"){
      updateSelectInput(session,"y",choices = c("_",unique(isparkparkbilgileri$ParkAdi))) 
    }else{
      updateSelectInput(session,"y",choices = c("_",unique(isparkparkbilgileri$ParkAdi[isparkparkbilgileri$Ilce==input$x])),selected = isolate(input$y))
    }
  })
  
  observeEvent(input$y,{
    if(input$y=="_"){
      updateSelectInput(session,"x",choices = c("_",unique(isparkparkbilgileri$Ilce))) 
    }else{
      updateSelectInput(session,"x",choices = c("_",unique(isparkparkbilgileri$Ilce[isparkparkbilgileri$ParkAdi==input$y])),selected = isolate(input$x))
    }
  } )
 
  
  # output$plot4<- renderPlot({
  #   
  #   
  #   parkcapacitylog<- parkcapacitylog %>% filter(ParkAdi %in% input$y)
  #   
  #   gunler <- wday(parkcapacitylog$OlcumZamani, label = TRUE)
  #   
  #   parkcapacitylogfordays <- aggregate(DolulukYuzdesi ~ OlcumZamanÄ± +gunler, parkcapacitylog, mean)
  #   
  #   ggplot(parkcapacitylogfordays, aes(x=OlcumZamani, y=DolulukYuzdesi, colour=gunler)) + 
  #     geom_path()+
  #     scale_x_datetime()+
  #     facet_grid(gunler ~.) +
  #     theme(legend.position="none")
  #   
  # })
  
  output$plot5 <- renderPlot({
    
    parkcapacitylog <- parkcapacitylog %>% filter(ParkAdi %in% input$y)
    
    
    park_capacity_hourly <- parkcapacitylog %>% 
      mutate(wday=lubridate::wday(OlcumZamanı,label=TRUE,abbr=FALSE), hour=lubridate::hour(OlcumZamanı)) %>% 
      group_by(wday, hour) %>%
      summarize(avd_doluluk_orani =mean(DolulukYuzdesi))
    
    park_capacity_hourly$Day <- factor(park_capacity_hourly$wday, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
    
    ggplot(park_capacity_hourly, aes(hour, avd_doluluk_orani, color=Day)) +
      geom_line() +
      #facet_grid(Day ~.) +
      scale_y_continuous(limits = c(0,100)) +
      scale_x_continuous(limits = c(0,23)) +
      labs(x="Hour", y="Average Occupancy Rate") +
      labs(title = "Average Hourly Parking Occupancy Rate of Ispark") +
      scale_color_brewer(palette="Paired") +
      theme_minimal()
  })
}


