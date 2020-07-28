library(shiny)
library(shinydashboard)
library(plotly)

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
    menuItem("Clustering", tabname="pca")
  )),
  
  #define the body of the app
  dashboardBody(
    tabItems(
      #About tab contents
      tabItem(tabName="about", class="active",
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
        "The ", strong("Data Set tab"), "contains the data set. It can be filtered based on wine type and quality.", br(),
        "The ", strong("Data Exlporation tab"), " gives an overview of the data, including frequency tables, histograms for Wine Quality, a correlation plot of all the numeric variables, and distribution plots for each numeric variable.", br(),
        "The ", strong("Modeling tab") ," contains a simple linear regression model, which the user can choose from 3 variables, and a bagged tree model, which the user can choose the number of trees.", br(),
        "The ", strong("Clustering tab"), " includes a dendogram."
      ),
      
      #Data Set tab contents
      tabItem(tabName="set", class="active",
        h2("The Data Set"),
        checkboxGroupInput("type", "Wine Type", selected=c("red","white"),
                           choices=c("red", "white")),
        downloadLink("downloadData","Download Data"), br(),
        dataTableOutput("table")
      ),
      
      #Data Exploration tab contents
      tabItem(tabName="data", class="active",
        h2("Data Exploration"),
        
        #Frequency tables
        h3("Frequency Table of Types of Wine"),
        "When using this data set for analyses and prediction models, it is important to note the discrepancy in the number of red wines sampled (1599) versus the number of white wines sampled (4898).", br(),
        dataTableOutput("freqTabAll"),
        
        h3("Frequency Table for Wine Quality"),
        "The table below shows the counts for the number of red wines and white wines in each quality level", br(),
        dataTableOutput("qualityFreqTab"),
        
        #Histograms of wine quality
        h3("Histogram of Wine Quality for All Wines"),
        "The histogram below shows the counts of wines for each quality level for both red and white wines. Notice, most wines are in the 5-7 range.", br(),
        downloadLink("downloadPlot", "Download Plots"), br(),
        plotlyOutput("histAll"),
        
        h3("Histogram of Wine Quality for Wines by Type"),
        "The histogram below breaks down the counts into red wines and white wines.", br(),
        plotlyOutput("histType"),
        
        #Correlation Plot
        h3("Correlation Plot of the Physiochemical Properties of Wine"),
        "The correlation plot below shows a visual representation of the correlation between the physiochemical property variables. Blue circles indicate a positive correlation, and red circle indicate a negative correlation. The larger and darker the circle, the stronger the correlation. Notice alcohol and density appear to have the strongest correlation. Total sulfur dioxide and free sulfur dioxide also have a notable correlation - though, this correlation is to be expected.", br(),
        plotOutput("corrs"),
        
        #Distributions of physiochemical variables
        h3("Distributions of Physiochemcial Variables"),
        "The plots below show the distributions of the physiochemical variables in the data set that contains both red wine and white wine.",
        plotlyOutput("distr")
        
      ),
      
      #Modeling tab contents
      tabItem(tabName="model", class="active",
        h2("Modeling"),
        br(),
        
        #SLR
        h3("Simple Linear Regression"),
        "Below is an interactive linear model. The user can choose from density, volatile acidity, and chlorides.",
        selectizeInput("lmCheck", "Linear Model Variable",
                       selected="density",
                       choices=c("density", "volatile acidity", "chlorides")
        ),
        uiOutput("lmText"),
        tableOutput("lmModel"),
        br(),
        
        #Classification tree
        h3("Classification Tree - Bagged Tree Model"),
        "Below is a classification tree. The user can select the number of trees.",
        br(),
        sliderInput("trees", "Number of Trees to Fit",
                    min=10, max=200, value=50, step=10
        ),
        uiOutput("bagText"),
        tableOutput("bag"),
        "Notice, RMSE stands for root mean square, and is calculated by:"
      ),
      
      #Clustering tab contents
      tabItem(tabName="pca", class="active",
        h2("Clustering"),
        plotOutput("dendo")
      )
    )
  )
)

