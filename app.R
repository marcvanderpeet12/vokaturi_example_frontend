library(shiny)
library(ggplot2)

UI <- fluidPage(
  div(style="display:inline-block", numericInput("start_time", "Starting time",1, min = 1, max = 100)),
  div(style="display:inline-block", numericInput("stop_time", "Stop time",1, min = 1, max = 100)),
  
  actionButton("start_counter", "Start the counter"),
  actionButton("stop_counter", "Stop the counter"),
  
  tags$audio(src = "sample_file.mpp3", type= "audio/mp3", autoplay = NA, controls= NA),
  
  #Setting up the plots now
  plotOutput("plot_timeseries1", width = "500px", height = "300px")
  
)
Server <- function(input, output, session){
  
  counter <- reactiveVal(1)
  action <- reactiveVal(FALSE)
  
  observeEvent(input$start_counter, {
    action(!action())
  })
  
  observe({ invalidateLater(1000, session)
    isolate({
      if(action() & counter() < input$stop_time) # MODIFIED - stop at stop time.
      {
        # Add 1 to our counter
        counter(counter() + 1) 
      }
      else # ADDED - to stop the timer from running when we modify the start or stop time.
      {
        action(FALSE) 
      }
    })
  })
  
  observeEvent(input$reset_counter, {
    counter(input$start_time)
  })

  pp <- eventReactive(c(input$start_time, input$stop_time, counter()), {
    ggplot(mtcars, aes(x = wt, y = mpg)) +
      geom_point() +
      scale_x_continuous(limits = c(input$start_time, input$stop_time)) +
      geom_vline(xintercept = counter())
  })
  
  output$plot_timeseries1 <- renderPlot({
    pp()
  })
}

shinyApp(ui = UI, server = Server)