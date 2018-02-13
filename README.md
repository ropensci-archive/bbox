bbox
====



[![Build Status](https://travis-ci.org/ropensci/bbox.svg?branch=master)](https://travis-ci.org/ropensci/bbox)
[![codecov](https://codecov.io/gh/ropensci/bbox/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/bbox)

`bbox` gets bounding boxes

Various interfaces:

* Input long/lat and value to make a polyogn, then get the bbox, using either
    * `sp`/`rgeos`, or
    * GeoJSON via `lawn` (to be replaced with `geoops` once `geoops::geo_buffer`)
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

sp/rgeos class spatial objects


```r
library(sp)
x <- GridTopology(c(0,0), c(1,1), c(5,5))
sp_grid <- SpatialGrid(x)
b_box(sp_grid)
#> [1] -0.5 -0.5  4.5  4.5
```

WKT


```r
wkt_poly <- "POLYGON ((100.001 0.001, 101.1235 0.0010, 101.001 1.001, 100.001 0.001))"
b_box(wkt_poly)
#> [1] 100.0010   0.0010 101.1235   1.0010
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/bbox/issues).
* License: MIT
* Get citation information for `bbox` in R doing `citation(package = 'bbox')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.
