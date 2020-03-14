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

tv_add <- function(., name, value) {
  .$x$settings[[name]] = value
  .
}

#' @export
tv_margins <- function(top = 0, bottom = 0) {
  list(top = top, bottom = bottom)
}

#' @export
tv_chart <- function(., decimals = 5, margins = tv_margins(0, 0)) {
  tv_add(.,
         name = "chart",
         value = list(decimals = decimals,
                      margins = margins))
}

#' @export
tv_line <- function(.,
                    name = NULL,
                    data = NULL,
                    value = "value",
                    width = 1,
                    color = NULL,
                    style = c("solid", "dotted", "dashed", "large-dashed", "sparse-dotted"),
                    type = c("normal", "steps"),
                    overlay = FALSE,
                    margins = tv_margins()) {
  if (is.null(name)) {
    name <- value
  }
  if (missing(style)) {
    style <- "solid"
  }
  if (missing(type)) {
    type <- "normal"
  }
  tv_add(.,
         name,
         list(type = "line",
              data = data,
              value = value,
              width = width,
              color = color,
              style = style,
              lineType = type,
              overlay = overlay,
              margins = margins))
}

#' @export
tv_histogram <- function(.,
                         name = NULL,
                         data = NULL,
                         time = "time",
                         base = NULL,
                         value = "value",
                         color = NULL,
                         mapping = NULL,
                         colors = NULL,
                         overlay = FALSE,
                         margins = tv_margins()) {
  if (is.null(name)) {
    name <- value
  }

  tv_add(.,
         name,
         list(type = "histogram",
              data = data,
              time = time,
              base = base,
              value = value,
              color = color,
              overlay = overlay,
              colors = colors,
              mapping = mapping,
              margins = margins))
}

#' @export
tv_candles <- function(.,
                       name = "candles",
                       data = NULL,
                       open = "open",
                       close = "close",
                       high = "high",
                       low = "low",
                       time = "time",
                       overlay = FALSE,
                       margins = tv_margins()) {
  tv_add(.,
         name,
         list(type = "candles",
              data = data,
              open = open,
              close = close,
              high = high,
              low = low,
              time = time,
              overlay = overlay,
              margins = margins))
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
