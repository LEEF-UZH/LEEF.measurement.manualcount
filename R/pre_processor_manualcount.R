#' Preprocessor manualcount data
#'
#' Just copy from input to output
#'
#' @param input directory from which to read the data
#' @param output directory to which to write the data
#'
#' @return invisibly \code{TRUE} when completed successful
#'
#' @export

pre_processor_manualcount <- function(
  input,
  output
) {
  message("\n########################################################\n")
  message("\nProcessing manualcount\n")
  ##
  dir.create(
    file.path(output, "manualcount"),
    recursive = TRUE,
    showWarnings = FALSE
  )
  file.copy(
    from = file.path(input, "manualcount", "."),
    to = file.path(output, "manualcount"),
    recursive = TRUE
  )
  ##
  message("done\n")
  message("\n########################################################\n")

  invisible(TRUE)
}
