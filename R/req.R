api_version <- function() "v2.1"

base_url <- function(domain, version = api_version()) {
  glue::glue("https://{domain}/api/explore/{version}")
}

user_agent <- function() "odsql (https://www.pattern.institute/odsql)"

#' Create a new HTTP request
#'
#' [req()] creates an HTTP request object.
#'
#' @param .res A resource (res) URL as a string. This string supports embedding
#'   of R variable names in curly braces whose values are looked up in parameter
#'   names supplied in `...` and interpolated.
#'
#' @param .dom Opendatasoft's Explore API domain (dom). The Explore API is
#'   accessed using a base URL that is specific to a domain. Defaults to
#'   global option returned by [domain()].
#'
#' @param ... Name value pairs specifying query components or parameters.
#'
#' @param .body A literal string or raw vector to send as body.
#'
#' @param .headers An S3 list with class `odsql_req_hdr`. Use the helper
#' [req_headers()] to create such an object.
#'
#' @inherit httr2::request return
#'
#' @examples
#' \dontrun{
#'
#' # Explicitly pass the API domain (`.dom`) to `req()`.
#' req(
#'   .dom = "documentation-resources.opendatasoft.com",
#'   .res = "/catalog/datasets/{dataset_id}",
#'   dataset_id = "roman-emperors",
#'   limit = 10
#'   )
#'
#' # Or define the API domain as a global option and omit `.dom` from subsequent
#' # calls to `req()`.
#' set_domain("documentation-resources.opendatasoft.com")
#' req(.res = "/catalog/datasets/{dataset_id}", dataset_id = "roman-emperors", limit = 10)
#' }
#'
#' @keywords internal
req <-
  function(.res,
           ...,
           .dom = domain(),
           .body = NULL,
           .headers = req_headers()) {

    if (is.null(.dom))
      cli::cli_abort("API domain {.var .dom} is not set.")

    # All parameters.
    params <- list(...)
    pnames <- names(params)

    # Required parameters.
    req_pnames <- vars_in_braces(.res)
    req_params <- params[req_pnames]

    # Optional parameters.
    opt_pnames <- setdiff(pnames, req_pnames)
    opt_params <- params[opt_pnames]

    res <- glue::glue(.res, .envir = as.environment(req_params))

    req <-
      httr2::request(base_url(domain = .dom)) |>
      httr2::req_url_path_append(res) |>
      httr2::req_url_query(!!!opt_params) |>
      httr2::req_headers(!!!.headers) |>
      httr2::req_user_agent(user_agent())

    if (!is.null(.body)) {
      req <- httr2::req_body_raw(req, body = .body, type = .headers$content_type)
    }

    req
  }
