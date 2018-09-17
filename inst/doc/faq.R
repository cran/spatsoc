## ----knitropts, include = FALSE------------------------------------------
knitr::opts_chunk$set(message = FALSE, 
                      warning = FALSE,
                      eval = FALSE, 
                      echo = TRUE)

## ---- eval = TRUE, results = 'hide'--------------------------------------
# Load packages
library(spatsoc)
library(data.table)

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

## ---- eval = TRUE, echo = FALSE------------------------------------------
knitr::kable(DT[order(group, timegroup)][1:5, .(ID, X, Y, datetime, timegroup, group)])

## ----posixct-------------------------------------------------------------
#  DT[, datetime := as.POSIXct(datetime)]
#  DT[, c('idate', 'itime') := IDateTime(datetime)]

## ----alloc---------------------------------------------------------------
#  if (truelength(DT) == 0) {
#    setDT(DT)
#  }
#  # then go to spatsoc
#  group_times(DT, datetime = 'datetime', threshold = '5 minutes')

