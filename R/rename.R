#' Generics. Rename columns in an odsql query.
#' 
#' @name rename
#' @export
rename <- function(.data, ...) {
  UseMethod("rename")
}

#' @rdname rename
#' @method rename odsql
#' @export
rename.odsql <- function(.data, ...) {
  if (!inherits(.data, "odsql")) {
    stop("`.data` must be an odsql object")
  }

  args <- rlang::enexprs(...)
  old_cols <- purrr::map_chr(args, rlang::expr_text)
  new_cols <- names(args)
  mapping <- rlang::set_names(new_cols, old_cols)
  
  .data$ops$rename <- mapping
  .data
}