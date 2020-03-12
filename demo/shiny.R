library(shiny)
library(tradingview)
library(tidyverse)
library(tidyquant)

aapl <- tq_get("AAPL") %>% mutate(time = date)

ui = shinyUI(fluidPage(
  tradingviewOutput("tv")
))

server = function(input, output) {
  output$tv <- renderTradingview({
    tradingview(aapl, list(
      chart = list(
        decimals = 2,
        margins = list(
          top = 0,
          bottom = 0.2
        )
      ),
      candles = list(
        type = "candles"
      ),
      volume = list(
        type = "histogram",
        value = "volume",
        color = "rgba(0,0,0,0.2)",
        overlay = TRUE,
        margins = list(
          top = 0.8,
          bottom = 0
        )
      )
    ), height = 400)
  })
}

shinyApp(ui = ui, server = server)
