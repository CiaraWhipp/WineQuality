library(shiny)
library(shinydashboard)

shinyUI(
# Define UI for application that draws a histogram
dashboardPage(skin = "blue",
  #add a title
  dashboardHeader(title="Wine Quality of Portugese Red and White Wines", titleWidth=750),
  
  #define sidebar items
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabname="about"),
    menuItem("Data Exploration", tabname="data"),
    menuItem("Modeling", tabname="model"),
    menuItem("Principle Components Analysis", tabname="pca")
  )),
  
  #define the body of the app
  dashboardBody(
    tabItems(
      #About tab contents
      tabItem(tabName="about"
      )
    )
  )
)
)
