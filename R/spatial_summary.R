#' Spatial data summary
#'
#' @param dir A dataset directory
#' @param aux Dataset with cell's id and precipitation values
#' @param dates_forcing Dataset with dates and forcing
#'
#' @return A completed dataset
#' @export spatial_summary
#'
#' @examples
spatial_summary <- function(dir,aux, dates_forcing){
  #Small preparation
  nc <- nc_open(dir)
  err <- try(expr = {p <- ncvar_get(nc, varid = 'pr')}, silent = TRUE)
  if (inherits(err, what = 'try-error')) {
    err <- try(expr = {p <- ncvar_get(nc, varid = 'precipitation_flux')}, silent = TRUE)
  }
  err <- try(expr = {lon <- ncvar_get(nc, varid = 'lon')}, silent = TRUE)
  if (inherits(err, what = 'try-error')) {
    err <- try(expr = {lon <- ncvar_get(nc, varid = 'longitude')}, silent = TRUE)
  }
  err <- try(expr = {lat <- ncvar_get(nc, varid = 'lat')}, silent = TRUE)
  if (inherits(err, what = 'try-error')) {
    err <- try(expr = {lat <- ncvar_get(nc, varid = 'latitude')}, silent = TRUE)
  }
  raster <- brick(p)
  extent(raster) <- c(range(lon), range(lat))

dt <- data.table(dates_forcing, aux)

mdt <- melt(dt, id.vars = c("date",'forcing'), variable.name = "id", variable.factor = FALSE)

mdt <- mdt[, c("lon", "lat") := as.data.table(xyFromCell(raster, as.numeric(as.character(id))))]

setnames(mdt, 'value', 'precipitation')

return(mdt)
}
