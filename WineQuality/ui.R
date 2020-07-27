library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(skin = "red",
  #add a title
  dashboardHeader(title="Wine Quality of Red and White Wines", titleWidth=750),
  
  #define sidebar items
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabname="about"),
    menuItem("Data Set", tabname="set"),
    menuItem("Data Exploration", tabname="data"),
    menuItem("Modeling", tabname="model"),
    menuItem("Principle Components Analysis", tabname="pca")
  )),
  
  #define the body of the app
  dashboardBody(
    tabItems(
      #About tab contents
      tabItem(tabName="about",
        h2("About the Data"),
        "This app explores the combination of the red wine quality data set and the white wine quality data set. Both datasets can be found here:", br(),
        a(href="https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", "Red wine data set"), br(),
        a(href="https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv", "White wine data set"), br(),
        h3("Variable Overview"),
        "Both data sets have 12 variables. The combined data set has an added thirteenth variable to indicate the type of wine. Below is a brief description for each variable.",
        br(),
        strong("Fixed Acidity:"), " acids in wine that do not readily evaporate - accounts for most of the acids found in wine", br(),
        strong("Volatile Acidity:"), " the amount of acetic acid in the wine - too much acetic acid can cause the wine to have a vinegar taste", br(),
        strong("Citric Acid:"), " the amount of citric acid in the wine - can add 'freshness' and flavor to wines", br(),
        strong("Residual Sugar:"), " the amount of sugar remaining after fermentation stops - wines with greater than 45 grams/liter are considered sweet wines", br(),
        strong("Chlorides:"), " the amount of salt in the wine", br(),
        strong("Free Sulfur Dioxide:"), " prevents microbial growth and oxidation of the wine - concentrations of over 50 ppm, sulfur dioxide becomes evident in the nose and the taste of the wine", br(),
        strong("Total Sulfur Dioxide:"), " the amount of free and bound forms of sulfur dioxide - generally undetectable in wine", br(),
        strong("Density:"), " the density of wine is close to the density of water - depends on alcohol and suagr content", br(),
        strong("pH:"), " how acidic or basic the wine is on a scale of 0 (extremely acidic) to 14 (extremely basic) - most wines have a pH between 3-4", br(),
        strong("Sulphates:"), " an additive that can contributes to sulfur dioxide gas levels - acts an antimicrobial and an antioxidant", br(), 
        strong("Alcohol:"), " percent alcohol content of the wine", br(),
        strong("Quality:"), " the output variable - quality of the wine is ranked on a scale of 0-10", br(),
        strong("Type:"), " indicates if the wine is red or white - only present in the combined data set", br(),
        
        #text describing the app
        h2("About the Application"),
        "The ", strong("Data Exlporation tab"), " gives an overview of the data. The summary table for numeric variables, the quality distribution, and the quality frequency table can be viewed for just the red or white wine datasets or for the overall, combined data set.",
        br(),
        "The ", strong("Data Set tab"), "contains the data set. It can be filtered based on wine type and quality.", br(),
        "The ", strong("Modeling tab") ," contains 2 interactive models for predicting wine quality.", br(),
        "The ", strong("Principle Components Analysis tab"), " includes an interactive biplot to explore principal components in the wine quality data."
      ),
      
      #Data Set tab contents
      tabItem(tabName="set",
        h2("The Data Set"),
        fluidRow(
          column(2,
                 checkboxGroupInput("type", "Wine Type", selected=c("red", "white"),
                                    choices=levels(as.factor(wineQuality$type))),
                 checkboxGroupInput("quality", "Wine Quality", 
                                      selected=c("3","4","5","6","7","8","9"),
                         choices=levels(as.factor(wineQuality$quality))),
                 downloadButton("download", "Download")),
          column(10, tableOutput("table"))
        )
      ),
      
      #Data Exploration tab contents
      tabItem(tabName="data", class="active",
        h2("Data Exploration"),
        
        #Frequency tables
        h3("Frequency Table of Types of Wine"),
        tableOutput("freqTabAll"),
        
        h3("Frequency Table for Wine Quality"),
        tableOutput("qualityFreqTab"),
        
        #Histograms of wine quality
        h3("Histogram of Wine Quality for All Wines"),
        plotOutput("histAll"),
        
        h3("Histogram of Wine Quality for Wines by Type"),
        plotOutput("histType"),
        
      ),
      
      #Modeling tab contents
      tabItem(tabName="model",
        h2("Modeling")
      ),
      
      #Principle Components Analysis tab contents
      tabItem(tabName="pca",
        h2("Principle Components Analysis")
      )
    )
  )
)

