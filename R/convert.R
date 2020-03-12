#' @export
as_tradingview_data <- function(x, ...) {
  UseMethod("as_tradingview_data")
}

#' @rdname as_tradingview_data
#' @export
as_tradingview_data.default <- function(x, ...) {
  x
}
