library(shiny)
library(tradingview)

ui = shinyUI(fluidPage(
  tradingviewOutput("tv")
))

server = function(input, output) {
  output$tv <- renderTradingview({
    tradingview(list())
  })
}

shinyApp(ui = ui, server = server)
