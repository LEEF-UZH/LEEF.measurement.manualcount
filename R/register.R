#' Register the processing of manualcount data in the LEEF package
#'
#' @return invisibly \code{TRUE} when completed successful
#'
#' @export
#'
register <- function() {
  if (is.null(system.file(package = "LEEF"))) {
    stop("This function requres the package to be installed!")
  }

  LEEF::add_pre_processor( pre_processor_manualcount )
  LEEF::add_extractor( extractor_manualcount )
  ##
  invisible(TRUE)
}

