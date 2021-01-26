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
  tmpdir <- tempfile()
  dir.create(tmpdir, recursive = TRUE)
  fns <- list.files(
    path = file.path(input, "manualcount"),
    pattern = "\\.xlsx$",
    full.names = TRUE,
    recursive = FALSE
  )
  if (length(fns) > 0) {
    if (length(fns) > 1) {
      warning("Only one `.xlsx` file expected! Only the first one will be abalysed!")
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

    x <- readxl::read_excel(
      path = fns[[1]],
      sheet = 1
    )
    utils::write.csv(
      x,
      file = file.path(tmpdir, csvn),
      row.names = FALSE
    )
  } else {
    message("Empty input directory - nothing to do!\n")
    message("\n########################################################\n")
  }

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

  file.copy(
    from = file.path(tmpdir, "."),
    to = file.path(output, "manualcount"),
    recursive = TRUE
  )
  unlink(tmpdir)
  file.copy(
    from = file.path(input, "sample_metadata.yml"),
    to = file.path(output, "manualcount", "sample_metadata.yml")
  )

  ##
  message("done\n")
  message("\n########################################################\n")

  invisible(TRUE)
}
