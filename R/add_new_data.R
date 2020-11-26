#' Check if data in input folder is OK and move to raw data folder
#'
#' @param input The folder, where a folder \code{manualcount} is located which
#'   contains the new files.
#' @param output A folder, which contains a subfolder called \code{manualcount}, i.e.
#'   the usually the raw data folder, into which the files will be moved to.
#'
#' @return a \code{list} which contains the individual results for each file.
#'   \code{TRUE} if moved, \code{FALSE} if an error occurred. Details of the error
#'   are in the error files in the \code{input/manualcount} directory.
#' @importFrom parallel mclapply
#' @importFrom utils capture.output read.csv
#' @export
#'
add_new_data <- function(input, output) {
  ##
  dir.create(
    file.path(output, "manualcount"),
    showWarnings = FALSE,
    recursive = TRUE
  )

  # Copy ALL other files ----------------------------------------------------

#   others <- grep(
#     list.files(
#       path = input,
#       full.names = TRUE
#     ),
#     pattern='.cxd',
#     invert=TRUE,
#     value=TRUE
#   )
#   file.copy(
#     from = others,
#     to = file.path(output, "bemovi"),
#     overwrite = TRUE
#   )
#   unlink( others )

  # Check and move folder ------------------------------------------------------

  files <- list.files(
    path = input,
    pattern = "\\.csv",
    full.names = FALSE
  )

  ##
  ok <- parallel::mclapply(
    files,
    function(f) {
      processing <- file.path(input, paste0("CHECKING.", f, ".CHECKING"))
      error <- file.path(input, paste0("ERROR.", f, ".txt"))

      on.exit(
        {
          if (file.exists(processing)) {
            unlink(processing)
            utils::capture.output(print(result), file = error)
          }
        }
      )
      ##
      file.create( processing )
      ##
      message("checking ", f)
      result <- list(
        ok = TRUE
      )

      # Check if file exist ----------------------------------------------------------

      x <- utils::read.csv(
        file.path(input, f),
        header = TRUE
      )

      result$names <- names(x) == c("date", "ID", "species", "vol_taken", "vol_diluted", "vol_counted", "count", "count_per_ml", "incubator", "treat")
      result$data <- nrow(x) >= 1

      result$ok <- all(unlist(result))

      if ( result$ok ) {
        file.copy(
          from = file.path(input, f),
          to = file.path(output, "manualcount"),
          recursive = FALSE,
          overwrite = TRUE
        )
        unlink( file.path(input, f) )
        unlink(processing)
      }
      return(result)
    }
  )
  names(ok) <- files
  return(ok)
}









