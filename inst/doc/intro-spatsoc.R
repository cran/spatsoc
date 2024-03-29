## ----knitropts, include = FALSE-----------------------------------------------
knitr::opts_chunk$set(message = TRUE, 
                      warning = FALSE,
                      eval = FALSE, 
                      echo = FALSE)

## ---- eval = TRUE, echo = TRUE------------------------------------------------
# Load packages
library(spatsoc)
library(data.table)

## ---- echo = FALSE, eval = TRUE-----------------------------------------------
data.table::setDTthreads(1)

## ---- eval = TRUE, echo = TRUE------------------------------------------------
# Read in spatsoc's example data
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Use subset of individuals
DT <- DT[ID %in% c('H', 'I', 'J')]

# Cast character column 'datetime' as POSIXct
DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]
DT <- DT[ID %chin% c('H', 'I', 'J')]

## ---- eval = TRUE, echo = FALSE-----------------------------------------------
knitr::kable(DT[, .SD[1:2], ID][order(ID)])

## ----groupmins, echo = TRUE---------------------------------------------------
#  group_times(DT, datetime = 'datetime', threshold = '5 minutes')

## ----tableSetUp, eval = TRUE--------------------------------------------------
nRows <- 9

## ----tabgroupmins, eval = TRUE------------------------------------------------
knitr::kable(
  group_times(DT, threshold = '5 minutes', datetime = 'datetime')[, 
    .(ID, X, Y, datetime, minutes, timegroup)][
      order(datetime)][
        1:nRows])

## ----grouphours, echo = TRUE--------------------------------------------------
#  group_times(DT, datetime = 'datetime', threshold = '2 hours')

## ----tabgrouphours, eval = TRUE-----------------------------------------------
knitr::kable(
  group_times(DT, threshold = '2 hours', datetime = 'datetime')[, 
    .(ID, X, Y, datetime, hours, timegroup)][
      order(datetime)][
        1:nRows])

## ----groupdays, echo = TRUE---------------------------------------------------
#  group_times(DT, datetime = 'datetime', threshold = '5 days')

## ----tabgroupdays, eval = TRUE------------------------------------------------
knitr::kable(
  group_times(DT, threshold = '5 days', datetime = 'datetime')[, .SD[sample(.N, 3)], by = .(timegroup, block)][order(datetime)][
        1:nRows, .(ID, X, Y, datetime, block, timegroup)])

## ----grouppts, echo = TRUE----------------------------------------------------
#  group_times(DT = DT, datetime = 'datetime', threshold = '15 minutes')
#  group_pts(DT, threshold = 50, id = 'ID', coords = c('X', 'Y'), timegroup = 'timegroup')

## ----fakegrouppts, eval = TRUE------------------------------------------------
DT <- group_times(DT = DT, datetime = 'datetime', 
                     threshold = '15 minutes')
DT <- group_pts(
    DT = DT,
    threshold = 50, id = 'ID', coords = c('X', 'Y'),
    timegroup = 'timegroup')

knitr::kable(
  DT[
      between(group,  771, 774)][order(timegroup)][
        1:nRows, .(ID, X, Y, timegroup, group)]
)

## ----fakegrouplines, echo = TRUE----------------------------------------------
#  utm <- 32736
#  
#  group_times(DT = DT, datetime = 'datetime', threshold = '1 day')
#  group_lines(DT, threshold = 50, projection = utm,
#              id = 'ID', coords = c('X', 'Y'),
#              timegroup = 'timegroup', sortBy = 'datetime')

## ----grouplines, eval = TRUE--------------------------------------------------
utm <- 32736

DT <- group_times(DT = DT, datetime = 'datetime', 
                threshold = '1 day')
DT <- group_lines(DT,
                  threshold = 50, projection = utm, 
                  id = 'ID', coords = c('X', 'Y'), 
                  sortBy = 'datetime', timegroup = 'timegroup')
knitr::kable(
  unique(DT[, .(ID, timegroup, group)])[, .SD[1:3], ID][order(timegroup)]
)

## ----fakegrouppolys, echo = TRUE----------------------------------------------
#  utm <- 32736
#  group_times(DT = DT, datetime = 'datetime', threshold = '8 days')
#  group_polys(DT = DT, area = TRUE, hrType = 'mcp',
#             hrParams = list('percent' = 95),
#             projection = utm,
#             coords = c('X', 'Y'), id = 'ID')

## ----grouppolys, eval = TRUE--------------------------------------------------
utm <- 32736
DT <- group_times(DT = DT, datetime = 'datetime', threshold = '8 days')
knitr::kable(
  data.frame(group_polys(
    DT, 
    area = TRUE, hrType = 'mcp',
           hrParams = list('percent' = 95),
           projection = utm,
           coords = c('X', 'Y'), id = 'ID')[
             , .(ID1, ID2, area, proportion)])
)

## ----edgedist, echo = TRUE----------------------------------------------------
#  group_times(DT = DT, datetime = 'datetime', threshold = '15 minutes')
#  edge_dist(DT, threshold = 50, id = 'ID', coords = c('X', 'Y'), timegroup = 'timegroup', fillNA = TRUE)

## ----fakeedgedist, eval = TRUE------------------------------------------------
DT <- group_times(DT = DT, datetime = 'datetime', 
                     threshold = '15 minutes')
edges <- edge_dist(DT, threshold = 50, id = 'ID', coords = c('X', 'Y'), timegroup = 'timegroup', fillNA = TRUE)

knitr::kable(
  edges[between(timegroup, 158, 160)]
)

## ----edgenn, echo = TRUE------------------------------------------------------
#  group_times(DT = DT, datetime = 'datetime', threshold = '15 minutes')
#  edge_nn(DT, id = 'ID', coords = c('X', 'Y'), timegroup = 'timegroup')

## ----fakeedgenn, eval = TRUE--------------------------------------------------
DT <- group_times(DT = DT, datetime = 'datetime', 
                     threshold = '15 minutes')
edges <- edge_nn(DT, id = 'ID', coords = c('X', 'Y'), timegroup = 'timegroup')

knitr::kable(
  edges[1:6]
)

