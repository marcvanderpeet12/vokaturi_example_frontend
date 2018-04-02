library(shiny)
library(ggplot2)

UI <- fluidPage(
  div(style="display:inline-block", numericInput("start_time", "Starting time",1, min = 1, max = 100)),
  div(style="display:inline-block", numericInput("stop_time", "Stop time",1, min = 1, max = 100)),
  
  actionButton("start_counter", "Start the counter"),
  actionButton("stop_counter", "Stop the counter"),
  
  #Setting up the plots now
  plotOutput("plot_timeseries1", width = "500px", height = "300px")
  
)
Server <- function(input, output, session){
  
  #This will set up 
  action <- reactiveVal(FALSE)
  

  pp <- eventReactive(c(input$start_time, input$stop_time), {
    ggplot(mtcars, aes(x = wt, y = mpg)) +
      geom_point() +
      scale_x_continuous(limits = c(input$start_time, input$stop_time))
  })
  
  output$plot_timeseries1 <- renderPlot({
    pp()
  })
}

shinyApp(ui = UI, server = Server)