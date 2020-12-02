#' Extractor manualcount data
#'
#' Convert all \code{.cvs} files in \code{manualcount} folder to \code{data.frame} and save as \code{.rds} file.
#'
#' This function is extracting data to be added to the database (and therefore make accessible for further analysis and forecasting)
#' from \code{.csv} files.
#'
#' @param input directory from which to read the data
#' @param output directory to which to write the data
#'
#' @return invisibly \code{TRUE} when completed successful
#' @importFrom yaml read_yaml
#' @importFrom utils read.csv
#'
#' @export
#'
extractor_manualcount <- function( input, output ) {
  message("\n########################################################\n")
  message("Extracting manualcount...\n")

  # Get csv file names ------------------------------------------------------

  manualcount_path <- file.path( input, "manualcount" )
  manualcount_files <- list.files(
    path = manualcount_path,
    pattern = "\\.csv$",
    full.names = TRUE,
    recursive = TRUE
  )

  if (length(manualcount_files) == 0) {
    message("nothing to extract\n")
    message("\n########################################################\n")
    return(invisible(FALSE))
  }

  if (length(manualcount_files) > 1) {
    warning("Only one `.csv` file expected! Only the first one will be abalysed!")
  }

  fn <- manualcount_files[[1]]

# Read file ---------------------------------------------------------------

  dat <- utils::read.csv(fn)
  dat$density <- dat$Count / dat$ml.counted

  timestamp <- yaml::read_yaml(file.path(input, "sample_metadata.yml"))$timestamp
  dat <- cbind(timestamp = timestamp, dat)

# SAVE --------------------------------------------------------------------

  add_path <- file.path( output, "manualcount" )
  dir.create( add_path, recursive = TRUE, showWarnings = FALSE )
  write.csv(
    dat,
    file = file.path(add_path, "manualcount.csv"),
    row.names = FALSE
  )
  file.copy(
    from = file.path(input, "sample_metadata.yml"),
    to = file.path(output, "sample_metadata.yml")
  )

# Finalize ----------------------------------------------------------------

  message("done\n")
  message("\n########################################################\n")

  invisible(TRUE)
}
