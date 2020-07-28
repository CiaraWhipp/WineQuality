library(shiny)
library(tidyverse)
library(DT)
library(ggplot2)
library(Hmisc)
library(corrplot)
library(randomForest)
library(plotly)

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
      newData <- wineQuality %>% filter(type==input$type)
  })
  
  #Create the data table 
  output$table <- renderDataTable({
      newData <- getData()
      newData
  })
  
  #Create a download buttons
  output$downloadData <- downloadHandler(
    filename=function(){paste0("wineQualityData", Sys.Date(),".csv")},
    content=function(file){
      write.csv(data,file)
    }
  )
  
  output$downloadPlot <- downloadHandler(
    filename=function(){paste0("wineQualityPlot", Sys.Date(),".png")},
    content=function(file){
      ggsave(file, plot=plotInput(), device ="png")
      }
  )
  
  #Frequency table for wine types - combined data set
  output$freqTabAll <- renderDataTable({
    table <- as.data.frame(table(wineQuality$type))
    colnames(table) = c("Wine Type", "Frequency")
    table
  })
  
  #Frequency table for quality
  output$qualityFreqTab <- renderDataTable({
    table <- as.data.frame(table(wineQuality$type, wineQuality$quality))
    colnames(table) = c("Wine Type", "Quality", "Frequency")
    table
  })
  
  #Histogram for all wines
  output$histAll <- renderPlotly({
      ggplot(wineQuality, aes(x=quality)) +
        geom_histogram(bins=8, fill="lightpink3")
  })
  
  #Histogram for wines by type
  output$histType <- renderPlotly({
      groupColors <- c(red="violetred4", white="rosybrown2")
      ggplot(wineQuality, aes(x=quality, fill=type)) +
        geom_histogram(position="dodge", bins=8) +
          scale_fill_manual(name="Wine Type", values=groupColors)
  })
  
  #Correlation plot
  output$corrs <- renderPlot({
    dataCorrs <- wineQuality %>% select(1:11)
    correlations <- rcorr(as.matrix(dataCorrs))
    corr <- correlations[[1]]
    corrplot(corr)
  })
  
  #Distributions
  output$distr <- renderPlotly({
    wineQuality %>% select(1:11) %>% pivot_longer(everything()) %>%
      ggplot(aes(x=value)) +
      facet_wrap(~ name, scales="free") + geom_density()
  })
  
  #Linear Model
  #Text
  output$lmText <- renderUI({
    paste0("The following table shows an ANOVA test for the simple linear model that attempts to model wine quality with ",input$lmCheck,".")
  })
  #Model
  output$lmModel <- renderTable({
    if(input$lmCheck=="density"){fit <- lm(quality ~ density, data=wineQuality)
    } else if(input$lmCheck=="volatile acidity"){
      fit <- lm(quality ~ `volatile acidity`, data=wineQuality)
    } else {
      fit <- lm(quality ~ chlorides, data=wineQuality)
    }
    table(anova(fit))
  })
  
  #Bagged Tree
  output$bag <- renderTable({
    wineQuality <- wineQuality %>% rename(fixedAcidity=`fixed acidity`, 
                                          volatileAcidity=`volatile acidity`, 
                                          citricAcid=`citric acid`, 
                                          residualSugar=`residual sugar`, 
                                          freeSulfurDioxide=`free sulfur dioxide`,
                                          totalSulfurDioxide=`total sulfur dioxide`)
    wineQuality$type <- as.factor(wineQuality$type)
    train <- sample(1:nrow(wineQuality), size=nrow(wineQuality)*0.8)
    test <- dplyr::setdiff(1:nrow(wineQuality), train)
    wineTrain <- wineQuality[train,]
    wineTest <- wineQuality[test,]
    bagFit <- randomForest(quality ~ ., data=wineQuality, mtry=ncol(wineQuality)-1, 
                            ntree=input$trees, importance=TRUE)
    bagPred <- predict(bagFit, newdata=wineTest)
    RMSE <- sqrt(mean((bagPred-wineTest$quality)^2))
    RMSE
  })
  #Text
  output$bagText <- renderUI({
    paste0("The RMSE for the bagged tree model fitted with ", input$trees, " trees is:")
  })
  
  #Clustering dendogram
  output$dendo <- renderPlot({
    hierClust <- hclust(dist(data.frame(wineQuality$quality)))
    plot(hierClust, xlab="")
  })
  
  
})
