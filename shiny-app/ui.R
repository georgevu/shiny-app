#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("How much should I pay for a diamond?"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("carats",
                   "Number of carats:",
                   min = min(diamonds$carat),
                   max = max(diamonds$carat),
                   value = 1),
       selectInput("clarity", "Choose Clarity", choices=unique(diamonds$clarity)),
       selectInput("color", "Choose Color", choices=sort(unique(diamonds$color))),
       selectInput("cut", "Choose Cut", choices=unique(diamonds$cut)),
       submitButton("Submit"),
       hr(),
       helpText("How much should I pay for my diamond?", br(), 
                "You can calculate what a diamond may cost according to the diamonds dataset available in ggplot2", br(),
                "1. Choose the carat weight by sliding the carats slider",br(),
                "2. Choose the color of the diamond by selecting the color from the drop down list",br(),
                "3. Choose the clarity of the diamond by selecting the clarity from the drop down list",br(),
                "4. Choose the cut of the diamond by selecting the cut from the drop down list",br(),
                "5. When ready click the submit button to get the price estimate.")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       textOutput("diamondPrice")
    )
  )
))
