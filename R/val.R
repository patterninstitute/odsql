#' Validate query verbs.
#' 
#' This internal function checks if the given verbs lie among the supported verbs, and dispatch
#' the specific validation for each verb.
#' 
#' @param verbs A named list with the verbs to be validated.
#' @return Returns invisible `TRUE` if all the verbs are valid; otherwise, raises an error.
#' @details
#' The currently supported verbs are
#' \itemize{
#'  \item `select`
#'  \item `where`
#'  \item `limit`
#'  \item `group_by`
#'  \item `sort`
#'  \item `offset`
#' }
#' 
#' @keywords internal
validate_verbs <- function(verbs) {
  # Supported verbs
  supp_vb <- c("select", "where", "limit", "group_by", "sort", "offset")

  # Check nonsupported (yet) verbs
  par_n <- names(verbs)
  inval <- setdiff(par_n, supp_vb)
  if (length(inval)) {
    cli::cli_abort(c(
      "x" = "Unsupported verb(s): {.val {inval}}"
    ))
  }
  
  if ("select" %in% supp_vb) validate_select(verbs[["select"]])
  if ("where" %in% supp_vb) validate_where(verbs[["where"]])
  if ("limit" %in% supp_vb) validate_limit()(verbs[["limit"]])
  
  invisible(TRUE)
}

#' Check extra commas in list of fields.
#' 
#' This internal function checks if a list of fields has extra commas between them, or at begining or at the end of the list.
#' 
#' @param value A character with the fields separated by comma.
#' @return Returns `TRUE` if leading comma is found; returns `FALSE` otherwise.
#' @keywords internal
has_extra_commas <- function(value) {
  if (value == "" || grepl("^,|,$|,,", value)) {
    return(TRUE)
  }
  return(FALSE)
}

#' Check invalid field names
#' 
#' This internal function checks if a list of fields has common invalid names, such as fields beginning with a number.
#' 
#' @param value A character with the fields separated by comma.
#' @return Returns `TRUE` if invalid field name is found; returns `FALSE` otherwise.
#' @keywords internal
has_invalid_field_name <- function(value) {
  parts <- trimws(strsplit(value, ",", fixed = TRUE)[[1]])
  valid_name <- "^[A-Za-z_][A-Za-z0-9_]*$"
  bad <- parts[!grepl(valid_name, parts)]
  if (length(bad)) {
    return(TRUE)
  }
  return(FALSE)
}

#' Validate the 'select' clause of an ODSQL query.
#' 
#' This internal function validates the `select` clause, ensuring that the specified fields
#' have valid syntax, with no extra commas or invalid names.
#' 
#' @param value A string representing the fields to be selected, separated by commas.
#' The `"*"` or `""` (empty) are valid too.
#' 
#' @return Returns invisible `TRUE` if `select` clause is valid; otherwise, raises an error.
#' 
#' @keywords internal
validate_select <- function(value) {
  if (identical(value, "*") || identical(value,"")) return(invisible(TRUE))
  
  # Check for extra commas or empty value
  if (has_extra_commas(value)) {
    cli::cli_abort(c(
      "x" = "Check select clause for extra commas or empty value."
    ))
  }

  # Check field names
  fields <- trimws(strsplit(value, ",", fixed = TRUE)[[1]])
  for(field in fields){
    if (has_invalid_field_name(field)) {
      cli::cli_abort(c(
        "x" = "Invalid field name {.val {field}} in select clause."
      ))
    }
  }
  
  invisible(TRUE)
  
}

#' Validate the 'where' clause of an ODSQL query.
#' 
#' This internal function validates the `where` clause, ensuring that the specified conditions
#' have valid syntax and valid operators.
#' 
#' @param value A string representing the `where` clause, with logical conditions combining fields,
#' operators and values.
#' 
#' @return Returns invisible `TRUE` if `where` clause is valid; otherwise, raises an error.
#' 
#' @keywords internal
validate_where <- function(value) {
  if (identical(value, "")) {
    cli::cli_abort(c(
      "x" = "The where clause must be non-empty"
    ))
  }

  # Check parentheses
  lpar <- gregexpr("\\(", value)[[1]]
  rpar <- gregexpr("\\)", value)[[1]]
  if (length(lpar[lpar > 0]) != length(rpar[rpar > 0])) {
    cli::cli_abort(c(
      "x" = "Unbalanced parentheses in where clause."
    ))
  }

  # Check quotes
  sq <- nchar(value) - nchar(gsub("'", "", value))
  dq <- nchar(value) - nchar(gsub('"', "", value))
  if (sq %% 2 != 0) {
    cli::cli_abort(c(
      "x" = "Unbalanced single quotes in where clause."
    ))
  }
  if (dq %% 2 != 0) {
    cli::cli_abort(c(
      "x" = "Unbalanced double quotes in where clause."
    ))
  }

  # Check presence of allowed operators by documentation
  word_ops <- grepl("\\b(AND|OR|NOT|LIKE|IN)\\b", toupper(value), perl = TRUE)
  sym_ops  <- grepl("<=|>=|!=|=|<|>", value, perl = TRUE)

  if (!(word_ops || sym_ops)) {
    cli::cli_abort(c(
      "x" = "No operators detected in where clause. Use: =, !=, >, <, >=, <=, AND, OR, NOT, LIKE, or IN."
    ))
  }

  invisible(TRUE)

}

#' Validate the 'limit' argument of an ODSQL query.
#' 
#' This internal function validates the `limit` argument, ensuring that it is an integer between -1 and 100.
#' 
#' @param value A numeric value representing the `limit` argument.
#' 
#' @return Returns invisible `TRUE` if `limit` argument is valid; otherwise, raises an error.
#' 
#' @keywords internal
validate_limit <- function(value) {
  if (!is.numeric(value) || length(value) != 1 || is.na(value)) {
    cli::cli_abort(c(
      "x" = "The limit argument must be a non-missing integer number."
    ))
  }

  if (value %% 1 != 0) {
    cli::cli_abort(c(
      "x" = "The limit argument must be an integer."
    ))
  }

  if (value < -1 || value > 100) {
    cli::cli_abort(c(
      "x" = "The limit argument must be an integer between -1 and 100."
    ))
  }

  invisible(TRUE)
  
}

#' Validate the 'group_by' clause of an ODSQL query.
#' 
#' This internal function validates the `group_by` clause, ensuring that the specified fields
#' have valid syntax, with no extra commas or invalid names.
#' 
#' @param value A string representing the fields to be aggregated, separated by commas.
#' 
#' @return Returns invisible `TRUE` if `group_by` clause is valid; otherwise, raises an error.
#' 
#' @keywords internal
validate_group_by <- function(value) {

  if (has_extra_commas(value)) {
    cli::cli_abort(c(
      "x" = "Check group_by clause for extra commas or empty value."
    ))
  }

  fields <- trimws(strsplit(value, ",", fixed = TRUE)[[1]])
  for(field in fields){
    if (has_invalid_field_name(field)) {
      cli::cli_abort(c(
        "x" = "Invalid field name {.val {field}} in group_by clause."
      ))
    }
  }
}


validate_sort <- function(value) {
  # TODO:
  # Documentation of this function,
  # Search conditions of sorting from Opendatasoft documentation
  # 
}

validate_offset <- function(value) {
  # TODO:
  # Documentation of this function,
  # Search conditions of offset from Opendatasoft documentation
  # 
}

