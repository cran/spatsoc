## ----knitropts, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(message = FALSE, 
                      warning = FALSE,
                      eval = FALSE, 
                      echo = TRUE)

## ---- eval = TRUE-------------------------------------------------------------
# Load packages
library(spatsoc)
library(data.table)

## ---- echo = FALSE, eval = TRUE-----------------------------------------------
data.table::setDTthreads(1)

## ---- eval = TRUE-------------------------------------------------------------
# Read data as a data.table
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Cast datetime column to POSIXct
DT[, datetime := as.POSIXct(datetime)]

# Temporal groups
group_times(DT, datetime = 'datetime', threshold = '5 minutes')

# Spatial groups
group_pts(
  DT,
  threshold = 50,
  id = 'ID',
  coords = c('X', 'Y'),
  timegroup = 'timegroup'
)

## ----posixct------------------------------------------------------------------
#  DT[, datetime := as.POSIXct(datetime)]
#  DT[, c('idate', 'itime') := IDateTime(datetime)]

## -----------------------------------------------------------------------------
#  group_polys(
#    DT,
#    area = FALSE,
#    projection = utm,
#    hrType = 'mcp',
#    hrParams = list(grid = 60, percent = 95),
#    id = 'ID',
#    coords = c('X', 'Y')
#  )

## ----setdt--------------------------------------------------------------------
#  if (truelength(DT) == 0) {
#    setDT(DT)
#  }
#  # then go to spatsoc
#  group_times(DT, datetime = 'datetime', threshold = '5 minutes')

## ----alloc--------------------------------------------------------------------
#  DT <- readRDS('path/to/data.Rds')
#  alloc.col(DT)

## -----------------------------------------------------------------------------
#  # Number of unique individuals
#  DT[, uniqueN(ID)]
#  
#  # Number of unique individuals by timegroup
#  DT[, uniqueN(ID), by = timegroup]

## -----------------------------------------------------------------------------
#  # Min, max datetime
#  DT[, range(datetime)]
#  
#  # Difference between relocations in hours
#  DT[order(datetime),
#     .(difHours = as.numeric(difftime(datetime, shift(datetime), units = 'hours'))),
#     by = ID]
#  
#  # Difference between relocations in hours
#  DT[order(datetime),
#     .(difMins = as.numeric(difftime(datetime, shift(datetime), units = 'mins'))),
#     by = ID]

## -----------------------------------------------------------------------------
#  # All individuals
#  DT[, .(minX = min(X),
#         maxX = max(X),
#         minY = min(Y),
#         maxY = max(Y),)]
#  
#  # By individual
#  DT[, .(minX = min(X),
#         maxX = max(X),
#         minY = min(Y),
#         maxY = max(Y),),
#     by = ID]

## -----------------------------------------------------------------------------
#  # Number of unique individuals by timegroup
#  DT[, uniqueN(ID), by = timegroup]
#  
#  # Number of unique individuals by group
#  DT[, uniqueN(ID), by = group]

