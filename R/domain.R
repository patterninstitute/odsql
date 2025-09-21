#' API domain as global option
#'
#' @description
#'
#' These functions allow to manage the global option `odsql_api_domain`.
#'
#' - `set_domain()`: set a domain as a global option.
#' - `unset_domain()`: unset a domain.
#' - `domain()`: get the domain option.
#'
#' @param domain An API domain passed as a string.
#'
#' @returns
#'
#' - `set_domain()`: a named list with key `odsql_api_domain`, and value the
#' domain set value.
#'
#' - `unset_domain()`: a named list with `odsql_api_domain` and domain value
#' just before it is unset.
#'
#' - `domain()`: a string with the set domain value, or `NULL` if not set.
#'
#' @name domain
NULL

#' @rdname domain
#' @export
set_domain <- function(domain) {
  options(odsql_api_domain = domain)
}

#' @rdname domain
#' @export
unset_domain <- function() {
  options(odsql_api_domain = NULL)
}


#' @rdname domain
#' @export
domain <- function() {
  getOption(x = "odsql_api_domain", default = NULL)
}
