
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Similarity App"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("num",
                   "Number of files:",
                   min = 2,
                   max = 20,
                   value = 2),
      fileInput("files", "Input .txt File (IMP: It must be saved as UTF-8 encoding)", multiple = TRUE, 
                accept = c(".txt"), placeholder = "Drag your files here"),
      submitButton("Submit", icon("refresh")),
      textInput("keyfile","Enter filename for Top 10 keyword counts: " , value = "1.txt", width = NULL, placeholder = "1.txt"),
      submitButton("submit")
    ),
    
    # Show a plot of the generated distribution
    #mainPanel(
    #  plotOutput("distPlot")
    #)
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Similarity Matrix", plotOutput("distPlot")), 
                  tabPanel("Top 10 file keywords", plotOutput("barPlot"))
      )
    )
  )
))



