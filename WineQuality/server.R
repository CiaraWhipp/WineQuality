library(shiny)
library(tidyverse)
library(ggplot2)
library(Hmisc)
library(corrplot)

#Read in and prepare data set to be used for the app
# Read in white and red wine quality data sets 
whiteWine <- read_delim("https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv", delim=";")
redWine <- read_delim("https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", delim=";")

#Create new variable in whiteWine and redWine datasets to indicate the type (red or white) of wine
whiteWine <- whiteWine %>% mutate(type = "white")
redWine <- redWine %>% mutate(type="red")

#Merge the two wine datasets into one (the dataset to be used by the app)
wineQuality <- rbind(whiteWine, redWine)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
  #Filter data based on wine quality
  getData <- reactive({
      newData <- wineQuality %>% filter(type==input$type) %>% filter(quality==input$quality)
  })
  
  #Create the data table 
  output$table <- renderTable({
      newData <- getData()
      newData
  })
  
  #Create a download button
  output$download <- downloadHandler(
    filename=paste0("wineQualityData-", Sys.Date(),".csv"),
    content=function(file){
      write.csv(data,file)
    }
  )
  
  #Frequency table for wine types - combined data set
  output$freqTabAll <- renderTable({
    table <- as.data.frame(table(wineQuality$type))
    colnames(table) = c("Wine Type", "Frequency")
    table
  })
  
  #Frequency table for quality
  output$qualityFreqTab <- renderTable({
    table <- as.data.frame(table(wineQuality$type, wineQuality$quality))
    colnames(table) = c("Wine Type", "Quality", "Frequency")
    table
  })
  
  #Histogram for all wines
  output$histAll <- renderPlot({
      ggplot(wineQuality, aes(x=quality)) +
        geom_histogram(bins=8, fill="lightpink3")
  })
  
  #Histogram for wines by type
  output$histType <- renderPlot({
      groupColors <- c(red="violetred4", white="rosybrown2")
      ggplot(wineQuality, aes(x=quality, fill=type)) +
        geom_histogram(position="dodge", bins=8) +
          scale_fill_manual(name="Wine Type", values=groupColors)
  })
  
  #Correlation plot
  output$corrs <- renderPlot({
    data <- wineQuality %>% select(1:11)
    correlations <- rcorr(as.matrix(data))
    corr <- correlations[[1]]
    corrplot(corr)
  })
})
