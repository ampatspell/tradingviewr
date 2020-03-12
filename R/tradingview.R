#' @import htmlwidgets
#' @export
tradingview <- function(data,
                        settings = NULL,
                        width = NULL,
                        height = NULL,
                        sizing = htmlwidgets::sizingPolicy(
                          defaultWidth = "100%",
                          knitr.figure = FALSE,
                          browser.fill = TRUE,
                          padding = 0
                        ),
                        viewer = c("internal", "external", "browser")) {

  if (missing(data)) {
    data <- c()
  }

  if (missing(settings)) {
    settings <- list()
  }

  data <- as_tradingview_data(data)
  type <- if (inherits(data, "data.frame")) "data.frame" else class(data)[[1]]

  x <- list(
    data = data,
    type = type,
    settings = settings
  )

  htmlwidgets::createWidget("tradingview",
                            x,
                            width = width,
                            height = height,
                            sizingPolicy = sizing)
}

#' @export
tradingviewOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "tradingview", width, height, package = "tradingview")
}
#' @export
renderTradingview <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, tradingviewOutput, env, quoted = TRUE)
}
