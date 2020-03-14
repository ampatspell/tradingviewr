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
    tradingview(aapl, height = 400) %>%
      tv_chart(decimals = 2, margins = tv_margins(0, 0.2)) %>%
      tv_candles() %>%
      tv_line(color = "rgba(255,0,0,0.2)", value = "close") %>%
      tv_histogram(value = "volume", color = "rgba(0,0,0,0.15)", overlay = TRUE, margins = tv_margins(0.8, 0))
  })
}

shinyApp(ui = ui, server = server)
