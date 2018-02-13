#' Get bbox from various spatial objects
#' 
#' @export
#' @param x various inputs, see examples
#' @return bounding box numeric values in the order `[minX, minY, maxX, maxY]` 
#' @examples
#' # sf classses
#' if (requireNamespace("sf", quietly = TRUE)) {
#' 
#' library(sf)
#' nc <- st_read(system.file("shape/nc.shp", package="sf"))
#' class(nc)
#' b_box(nc)
#' 
#' (mix <- st_sfc(st_geometrycollection(list(st_point(1:2))),
#'   st_geometrycollection(list(st_linestring(matrix(1:4,2))))))
#' class(mix)
#' b_box(mix)
#' 
#' (x <- st_point(c(1,2,3,4)))
#' b_box(x)
#' 
#' }
#' 
#' # SpatialPolygons class
#' if (requireNamespace("sp", quietly = TRUE)) {
#' 
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' class(sp_poly)
#' b_box(sp_poly)
#' 
#' # SpatialGrid class
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' sp_grid <- SpatialGrid(x)
#' b_box(sp_grid)
#' 
#' }
#' 
#' # Character strings
#' if (requireNamespace("geojson") && requireNamespace("lawn") && requireNamespace("sf")) {
#' 
#' ## GeoJSON
#' ### featurecollection
#' geo_fc <- '{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[[-114.3457031,39.436193],[-114.3457031,43.4529189],[-106.6113281,43.4529189],[-106.6113281,39.436193],[-114.3457031,39.436193]]]},"properties":{}}]}'
#' b_box(geo_fc)
#' ### feature
#' geo_feature <- '{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[[-114.3457031,39.436193],[-114.3457031,43.4529189],[-106.6113281,43.4529189],[-106.6113281,39.436193],[-114.3457031,39.436193]]]}}'
#' b_box(geo_feature)
#' ### polygon
#' geo_poly <- '{"type":"Polygon","coordinates":[[[-114.3457031,39.436193],[-114.3457031,43.4529189],[-106.6113281,43.4529189],[-106.6113281,39.436193],[-114.3457031,39.436193]]]}'
#' b_box(geo_poly)
#' 
#' ## Well known text
#' wkt_poly <- "POLYGON ((100.001 0.001, 101.1235 0.0010, 101.001 1.001, 100.001 0.001))"
#' b_box(wkt_poly)
#' 
#' # many classes of varying types at once, passed in a list
#' b_box(list(nc, mix, sp_poly, sp_grid))
#' ## with an invalid type
#' b_box(list(nc, mix, sp_poly, sp_grid, 5))
#' ## remove it easily with Filter
#' Filter(Negate(is.null), b_box(list(nc, mix, sp_poly, sp_grid, 5)))
#' 
#' }

b_box <- function(x) {
  UseMethod("b_box")
}

#' @export
b_box.default <- function(x) {
  # stop("no 'b_box' method for ", class(x)[[1L]])
  return(NULL)
}

#' @export
b_box.list <- function(x) lapply(x, b_box)

#' @export
b_box.sf <- function(x) do_sf(x)
#' @export
b_box.sfg <- function(x) do_sf(x)
#' @export
b_box.sfc <- function(x) do_sf(x)

#' @export
b_box.SpatialPolygons <- function(x) c(sp::bbox(x))
#' @export
b_box.SpatialGrid <- function(x) c(sp::bbox(x))

#' @export
b_box.character <- function(x) {
  check4pkg("geojson")
  check4pkg("lawn")
  check4pkg("sf")

  if (grepl("\\{", x)) { # if GeoJSON
    # if polygon already
    geo <- geojson::to_geojson(x)
    geojson::geo_type(geo)
    lawn::lawn_extent(unclass(geo))
  } else if (grepl("\\(\\(", x)) { # if WKT
    do_sf(sf::st_as_sfc(x))
  } else { # no other character inputs supported
    stop("only GeoJSON and WKT types supported")
  }
}


# helpers -----------
do_sf <- function(x) {
  check4pkg("sf")
  tmp <- sf::st_bbox(x)
  tmp <- unname(unclass(tmp))
  attributes(tmp) <- NULL
  return(tmp)
}
