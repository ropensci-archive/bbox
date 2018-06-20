#' Bounding box from lon and lat values
#' 
#' @export
#' @param lon (numeric) longitude
#' @param lat (numeric) latitude
#' @param width (numeric) width, passed on to [rgeos::gBuffer()], see it's 
#' docs for more info. units are metric, so 10 is 10 m, 1000 is 1000 m, 
#' etc.
#' @param dist (numeric) distance. passed on to [lawn::lawn_buffer()]
#' @param units (character) units. passed on to [lawn::lawn_buffer()]. 
#' Default: kilometers
#' @param method (character) which method to use, either combination of \pkg{sp}
#' and \pkg{rgeos} ("sp_rgeos") or \pkg{lawn}
#' @param ... additional parameters passed on to [rgeos::gBuffer()]
#' @return bounding box numeric values in the order `[minX, minY, maxX, maxY]`
#' @examples
#' # 10m
#' lonlat2bbox(lon=-120, lat=45, width=10)
#' # 100m
#' lonlat2bbox(-120, 45, 100)
#' # 1000m, or 1 km
#' lonlat2bbox(-120, 45, 1000)
#' # 10 km
#' lonlat2bbox(-120, 45, 10^4)
lonlat2bbox <- function(lon, lat, width = NULL, dist = NULL, 
  units = "kilometers", method = "sp_rgeos", ...) {

  if (method == "sp_rgeos") {
    check4pkg("sp")
    check4pkg("rgeos")
    check4pkg("rgdal")
    pt <- sp::SpatialPoints(sp::coordinates(list(x = lon, y = lat)), 
      sp::CRS("+proj=longlat +datum=WGS84"))
    ## transfrom to web mercator becuase geos needs project coords
    crs <- gsub("\n", "", paste0("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0
       +y_0=0 +k=1.0 +units=m +nadgrids=@@null +wktext +no_defs", collapse = ""))
    pt <- sp::spTransform(pt, sp::CRS(crs))
    ## buffer
    pt <- rgeos::gBuffer(pt, width = width, ...)
    # transform back to latlon
    pt <- sp::spTransform(pt, sp::CRS("+proj=longlat +datum=WGS84"))
    # get bbox and make a vector
    c(sp::bbox(pt))
  } else {
    check4pkg("lawn")
    x <- sprintf(pt_template, lon, lat)
    poly <- jsonlite::toJSON(
      unclass(lawn::lawn_buffer(x, dist, units)),
      auto_unbox = TRUE
    )
    lawn::lawn_extent(poly)
  }
}

pt_template <- '{
 "type": "Feature",
 "properties": {},
 "geometry": {
    "type": "Point",
    "coordinates": [%s, %s]
  }
}'

