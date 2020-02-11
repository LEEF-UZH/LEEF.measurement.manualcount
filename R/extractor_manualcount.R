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
#'
#' @importFrom dplyr bind_rows
#' @importFrom readr read_csv
#' @export
#'
extractor_manualcount <- function( input, output ) {
  message("\n########################################################\n")
  message("Extracting manualcount...\n")

  # Get csv file names ------------------------------------------------------

  manualcount_path <- file.path( input, "manualcount" )
  manualcount_files <- list.files(
    path = manualcount_path,
    pattern = "*.csv",
    full.names = TRUE,
    recursive = TRUE
  )

  if (length(manualcount_files) == 0) {
    message("nothing to extract\n")
    message("\n########################################################\n")
    return(invisible(FALSE))
  }

# Read file ---------------------------------------------------------------

  mc <- lapply(
    manualcount_files,
    readr::read_csv
  )
  # combine intu one large tibble
  mc <- dplyr::bind_rows(mc)

# SAVE --------------------------------------------------------------------

  add_path <- file.path( output, "manualcount" )
  dir.create( add_path, recursive = TRUE, showWarnings = FALSE )
  saveRDS(
    object = mc,
    file = file.path(add_path, "manualcount.rds")
  )

# Finalize ----------------------------------------------------------------

  message("done\n")
  message("\n########################################################\n")

  invisible(TRUE)
}
