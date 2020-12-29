library(shiny)
library(leaflet)
library(RColorBrewer)
library(stringr)
library(dplyr)
library(ggplot2)
library(lubridate)


function(input, output, session){
  
  
  
  colorpal <- reactive({
    colorNumeric("RdYlGn", isparkparkbilgileri$OrtalamaDoluluk)
  })
  
  datafilt <- reactive({
    df1 <- isparkparkbilgileri  %>% filter(Kapasitesi >= input$total[1], Kapasitesi <= input$total[2]) %>% 
    #df2 <- isparkparkbilgileri %>% 
      filter((100-OrtalamaDoluluk) >= input$occupancyrate[1], (100-OrtalamaDoluluk) <= input$occupancyrate[2])
    #df3 <- isparkparkbilgileri %>%
    if (input$district != "All") {
      df1 <- df1 %>% filter(Ilce %in% input$district)
    } else {
      df1 <- df1
    }
  })
  
  datafiltplot <- reactive({
    parklarveilceler <- isparkparkbilgileri %>% select("ParkID","Ilce")
    parkcapacitylog <- parkcapacitylog %>% right_join(., parklarveilceler, by="ParkID")
    if (input$x == "Please Select a District" && input$y == "Please Select a Park Area") {
      df1 <- parkcapacitylog
    } else if (input$x != "Please Select a District" && input$y == "Please Select a Park Area") {
      df1 <- parkcapacitylog %>% filter(Ilce %in% input$x)
    } else {
      df1 <- parkcapacitylog %>% filter(ParkAdi %in% input$y)
    }
    
  })
  
  plotheader <- reactive({
    if (input$x == "Please Select a District" && input$y == "Please Select a Park Area") {
      header <- "Average Hourly Parking Occupancy Rate of All Park Areas"
    } else if (input$x != "Please Select a District" && input$y == "Please Select a Park Area") {
      header <- paste0("Average Hourly Parking Occupancy Rate of Park Areas in ", input$x)
    } else {
      header <- paste0("Average Hourly Parking Occupancy Rate of ", input$y)
    }
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
    if(input$x=="Please Select a District"){
      updateSelectInput(session,"y",choices = c("Please Select a Park Area",unique(isparkparkbilgileri$ParkAdi))) 
    }else{
      updateSelectInput(session,"y",choices = c("Please Select a Park Area",unique(isparkparkbilgileri$ParkAdi[isparkparkbilgileri$Ilce==input$x])),selected = isolate(input$y))
    }
  })
  
  observeEvent(input$y,{
    if(input$y=="Please Select a Park Area"){
      updateSelectInput(session,"x",choices = c("Please Select a District",unique(isparkparkbilgileri$Ilce))) 
    }else{
      updateSelectInput(session,"x",choices = c("Please Select a District",unique(isparkparkbilgileri$Ilce[isparkparkbilgileri$ParkAdi==input$y])),selected = isolate(input$x))
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
    
    parkcapacitylog <- datafiltplot()
    header <- plotheader()
    
    park_capacity_hourly <- parkcapacitylog %>% 
      mutate(wday=lubridate::wday(OlcumZamanı,label=TRUE,abbr=FALSE), hour=lubridate::hour(OlcumZamanı)) %>% 
      group_by(wday, hour) %>%
      summarize(avd_doluluk_orani =mean(DolulukYuzdesi))
    
    park_capacity_hourly$Day <- factor(park_capacity_hourly$wday, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
    
    ggplot(park_capacity_hourly, aes(hour, avd_doluluk_orani, color=Day)) +
      geom_line() +
      #facet_grid(Day ~.) +
      scale_y_continuous(limits = c(0,100)) +
      labs(x="Hour", y="Average Occupancy Rate") +
      labs(title = header) +
      scale_color_brewer(palette="Paired") +
      theme_minimal()
  })
}


