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
#' @importFrom utils read.csv write.csv
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

	manualcount_files <- grep(
	  "composition|experimental_design|dilution",
	  manualcount_files,
	  invert = TRUE,
	  value = TRUE
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
  dat$density <- dat$count / dat$ml_counted

  timestamp <- yaml::read_yaml(file.path(input, "manualcount", "sample_metadata.yml"))$timestamp
  dat <- cbind(timestamp = timestamp, dat)

  names(dat) <- tolower(names(dat))

# SAVE --------------------------------------------------------------------

  add_path <- file.path( output, "manualcount" )
  dir.create(
    add_path,
    recursive = TRUE,
    showWarnings = FALSE
  )
  utils::write.csv(
    dat,
    file = file.path(add_path, "manualcount.csv"),
    row.names = FALSE
  )

  fns <- grep(
    basename(fn),
    list.files(file.path(input, "manualcount")),
    invert = TRUE,
    value = TRUE
  )
  file.copy(
    from = file.path(input, "manualcount", fns),
    to = file.path(output, "manualcount", "")
  )

# Finalize ----------------------------------------------------------------

  message("done\n")
  message("\n########################################################\n")

  invisible(TRUE)
}
