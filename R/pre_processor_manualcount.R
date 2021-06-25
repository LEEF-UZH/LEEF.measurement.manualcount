#' Preprocessor manualcount data
#'
#' Just copy from input to output
#'
#' @param input directory from which to read the data
#' @param output directory to which to write the data
#'
#' @return invisibly \code{TRUE} when completed successful
#' @importFrom readxl read_excel
#' @importFrom utils write.csv
#' @export

pre_processor_manualcount <- function(
  input,
  output
) {
  message("\n########################################################\n")
  message("\nProcessing manualcount\n")
  ##

  if ( length( list.files( file.path(input, "manualcount") ) ) == 0 ) {
    message("\nEmpty or missing manualcount directory - nothing to do.\n")
    message("\ndone\n")
    message("########################################################\n")
    return(invisible(TRUE))
  }

  fns <- list.files(
    path = file.path(input, "manualcount"),
    pattern = "\\.xlsx$",
    full.names = TRUE,
    recursive = FALSE
  )
  if (length(fns) > 0) {
    if (length(fns) > 1) {
      warning("Only one `.xlsx` file expected! Only the first one will be analysed!")
    }
    fn <- fns[[1]]
    if (length(readxl::excel_sheets(fn)) > 1) {
      warning("Only one sheet in the excel workbook expected! Only the first one will be abalysed!")
    }

    csvn <- gsub(
      pattern = "\\.xlsx$",
      replacement = ".csv",
      basename(fn)
    )

    dir.create(
      file.path(output, "manualcount"),
      recursive = TRUE,
      showWarnings = FALSE
    )
    file.copy(
      file.path( input, "..", "00.general.parameter", "." ),
      file.path( output, "manualcount" ),
      recursive = TRUE,
      overwrite = TRUE
    )

    x <- readxl::read_excel(
      path = fn,
      sheet = 1
    )
    utils::write.csv(
      x,
      file = file.path(tmpdir, csvn),
      row.names = FALSE
    )

	  dir.create(
  	  file.path(output, "manualcount", "manualcount"),
   	 recursive = TRUE,
   	 showWarnings = FALSE
  	)
  }

 ##
  message("done\n")
  message("\n########################################################\n")

  invisible(TRUE)
}
