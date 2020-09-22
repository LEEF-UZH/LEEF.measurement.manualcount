#' Check if data in raw data folder is OK
#'
#' @param input raw data folder containing manualcount data, i.e usually is \code{some/path/mnualcount}
#'
#' @return \code{TRUE} if ok, \code{FALSE} or \code{list} of problems if not
#' @importFrom utils read.delim
#' @export
#'
#' @examples
#' \dontrun{
#' raw_data_ok()
#' }
raw_data_ok <- function(input) {
  ok <- list()

  on.exit(
    if (all(unlist(ok))) {
      return(TRUE)
    } else {
      return(ok)
    }
  )

  # ok$manualcount_extract <- file.exists( file.path(input, "manualcount", "manualcount_extract.yml") )
  # ok$video_description <- file.exists( file.path(input, "manualcount", "video.description.txt") )

  ok$data_present <- length(
    list.files(
      path = file.path( input, "manualcount" ),
      pattern = "\\.csv",
      full.names = FALSE
    )
  ) > 0

  return(ok)
}
