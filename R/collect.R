#' Generics. Collect ODSQL object and build the API query.
#' 
#' @name collect
#' @export
collect <- function(.data, ...) { 
  UseMethod("collect")
}

#' Collect ODSQL object and build the API query
#' @rdname collect
#' @method collect odsql
#' @export
collect.odsql <- function(.data, ...) {
  if (!inherits(.data, "odsql")) {
    stop("`.data` must be an odsql object")
  }
  .data <- generate_query(.data)
  .data
}