#' Reading dates and focing from filename
#'
#' @param dir A directory of the raw files
#'
#' @return A dataset with date and forcing columns
#' @export read_Dates_forcing
#'
#' @examples
read_Dates_forcing <- function(dir){
dates <- strsplit(substr(dir, start = nchar(dir) - 27, stop = nchar(dir) - 3), '-')
date_model_ID <- data.table(date = seq(as.POSIXct(dates[[1]][1], format = "%Y%m%d%H%M"),
                                       as.POSIXct(dates[[1]][2], format = "%Y%m%d%H%M"), by = 'hour'),
                            forcing = sapply(strsplit(dir, '_'), function(x)x[7]))
}
