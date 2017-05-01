#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(scales)
# Define server logic required to draw a histogram
cuberoot_trans = function() trans_new('cuberoot',
                                      transform = function(x) x^(1/3),
                                      inverse = function(x) x^3)  

m1 <- lm(I(log10(price)) ~ I(carat^(1/3)), data = diamonds)
m2 <- update(m1,~ . +carat)
m3 <- update(m2,~ . +cut)
m4 <- update(m3,~ . +color)
m5 <- update(m4,~ . +clarity)

shinyServer(function(input, output) {
  
  thisDiamond <- reactive({data.frame(carat=input$carats, cut=input$cut,
                           color=input$color,clarity=input$clarity)})
  modelEstimate <- reactive({predict(m5, newdata = thisDiamond(),
                           interval = "prediction",level = .95)})
  diamondPrice <- reactive({10^modelEstimate()})
  output$distPlot <- renderPlot({
    ggplot(aes(x = carat, y = price), data = diamonds) + 
      geom_point(alpha = 0.5, size = 1, position = 'jitter', aes(color=color)) +
      scale_color_brewer(type = 'div',
                         guide = guide_legend(title = 'Color', reverse = F,
                                              override.aes = list(alpha = 1, size = 2))) +                         
      scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                         breaks = c(0.2, 0.5, 1, 2, 3)) + 
      scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                         breaks = c(350, 1000, 5000, 10000, 15000)) +
      ggtitle('Price (log10) by Cube-Root of Carat and Color') +
      geom_hline(yintercept = diamondPrice()[1]/10.0) +
      geom_smooth(method = "lm", se=FALSE, fullrange=TRUE)
  })
    
  output$diamondPrice <- renderText({
    paste0("Your diamond should be priced around $", format(round(diamondPrice()[1], 2), nsmall = 2))
  })
  
})
