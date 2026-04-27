## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = TRUE,
  echo = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(spatsoc)
library(data.table)

## -----------------------------------------------------------------------------
# Read example data
DT <- fread(system.file('extdata', 'DT.csv', package = 'spatsoc'))

coords <- c('X', 'Y')
crs <- 32736
datetime <- 'datetime'
id <- 'ID'

## -----------------------------------------------------------------------------
# Get geometry
get_geometry(DT, coords = coords, crs = crs)

print(DT)

## -----------------------------------------------------------------------------
library(sftrack)
data("raccoon")
raccoon$timestamp <- as.POSIXct(raccoon$timestamp, "EST")
burstz <- list(id = raccoon$animal_id, month = as.POSIXlt(raccoon$timestamp)$mon)
my_track <- as_sftrack(raccoon,
  group = burstz, time = "timestamp",
  error = NA, coords = c("longitude", "latitude")
)

DT_sftrack <- as.data.table(my_track)

print(DT_sftrack)

## -----------------------------------------------------------------------------
library(move2)
fishers <- mt_read(mt_example(file = "fishers.csv.gz"))
DT_move2 <- as.data.table(fishers)

print(DT_move2)

## -----------------------------------------------------------------------------
library(sf)
DT[, st_bbox(geometry)]
DT[1:10, st_bbox(geometry)]

DT[, plot(geometry)]
DT[1:10, plot(geometry)]

# Note the bbox can also be manually recomputed
DT[1:10, st_bbox(st_sfc(geometry, recompute_bbox = TRUE))]
DT[1:10, plot(st_sfc(geometry, recompute_bbox = TRUE))]

## -----------------------------------------------------------------------------
DT_sf <- st_as_sf(DT, sf_column_name = 'geometry')
print(DT_sf)
plot(DT_sf)

## -----------------------------------------------------------------------------
library(sftrack)

# First convert to sf as above
DT_sf <- st_as_sf(DT, sf_column_name = 'geometry')
# Then convert to sftrack
DT_sftrack <- as_sftrack(DT_sf, group = c(id = id), time = datetime)

head(DT_sftrack)
plot(DT_sftrack)

## -----------------------------------------------------------------------------
library(move2)

# Convert to a {move2} object using mt_as_move2
DT_move2 <- mt_as_move2(DT,
  time_column = datetime,
  track_id_column = id,
  sf_column_name = 'geometry'
)

print(DT_move2)
plot(DT_move2)

