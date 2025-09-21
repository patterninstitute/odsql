#' Creates an Opendatasoft Query Language (odsql) object
#'
#' @param dataset_id Character, identifier of the dataset
#' @export
odsql <- function(dataset_id) {
  stopifnot(is.character(dataset_id), length(dataset_id) == 1)
  ops <- list(
    select = NULL,
    rename = NULL,
    filter = NULL,
    arrange = NULL,
    slice_head = NULL,
    mutate = NULL,
    group_by = NULL,
    query = NULL
  )

  structure(
    list(
      dataset_id = dataset_id,
      ops = ops
    ),
    class = "odsql"
  )
}
