bbox
====



[![Build Status](https://travis-ci.org/ropensci/bbox.svg?branch=master)](https://travis-ci.org/ropensci/bbox)
[![codecov](https://codecov.io/gh/ropensci/bbox/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/bbox)

`bbox` gets bounding boxes

Various interfaces:

* Input long/lat and value to make a polyogn, then get the bbox, using either
    * `sp`/`rgeos`, or
    * GeoJSON via `lawn`
* Input Spatial objects (`sp` package) and spit out the bbox
* Input GeoJSON data and spit out the bbox
* Input Well Know Text data and spit out the bbox
* Input Simple Features (`sf` package) data and spit out the bbox


## Installation


```r
remotes::("ropensci/bbox")
```


```r
library("bbox")
```

## lon/lat to bbox


```r
lonlat2bbox(lon=-120, lat=45, width=10^4)
#> [1] -120.08983   44.93644 -119.91017   45.06349
```

## get bbox from any spatial object


```r
library(sf)
nc <- st_read(system.file("shape/nc.shp", package="sf"))
#> Reading layer `nc' from data source `/Library/Frameworks/R.framework/Versions/3.4/Resources/library/sf/shape/nc.shp' using driver `ESRI Shapefile'
#> Simple feature collection with 100 features and 14 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> epsg (SRID):    4267
#> proj4string:    +proj=longlat +datum=NAD27 +no_defs
b_box(nc)
#> [1] -84.32385  33.88199 -75.45698  36.58965
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/bbox/issues).
* License: MIT
* Get citation information for `bbox` in R doing `citation(package = 'bbox')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.
