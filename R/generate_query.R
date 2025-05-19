generate_select_string <- function(.data) {
  select <- .data$ops$select
  rename <- .data$ops$rename

  if (is.null(select) && is.null(rename)) {
    return("*")
  }

  fields <- union(select, names(rename))

  columns <- vapply(fields, function(f) {
    if (!is.null(rename) && f %in% names(rename)) {
      glue::glue("{f} AS {rename[[f]]}")
    } else {
      f
    }
  }, character(1))

  paste(columns, collapse = ", ")
}


generate_query <- function(.data) {
  if (!inherits(.data, "odsql")) {
    stop("`.data` must be an odsql object")
  }

  str_select <- generate_select_string(.data)

  base <- glue::glue("GET /api/explore/v2.1/catalog/datasets/{.data$dataset}/records?")
  params <- list()

  params$select <- glue::glue("select={str_select}")
  # Add future verbs at params$[verb_name] here 

  query <- paste0(base, paste(params, collapse = "&"))
  
  .data$query <- query
  .data
}