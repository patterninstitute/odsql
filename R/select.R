#' Generics. Select columns in an odsql query.
#' 
#' @name select
#' @export
select <- function(.data, ...) { 
  UseMethod("select")
}

#' @rdname select
#' @method select odsql
#' @export
select.odsql <- function(.data, ...) {
  if (!inherits(.data, "odsql")) {
    stop("`.data` must be an odsql object")
  }
  
  out <- rlang::enquos(..., .named = FALSE)
  .data$ops$select <- vapply(out, rlang::as_label, character(1))
  .data
}