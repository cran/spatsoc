## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  echo = TRUE,
  comment = "#>"
)

## ---- eval = TRUE-------------------------------------------------------------
## Load packages
library(spatsoc)
library(data.table)

## ---- echo = FALSE, eval = TRUE-----------------------------------------------
data.table::setDTthreads(1)

## ---- eval = TRUE-------------------------------------------------------------
## Read data as a data.table
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

## Cast datetime column to POSIXct
DT[, datetime := as.POSIXct(datetime)]

## ---- eval = TRUE-------------------------------------------------------------
# Temporal groups
group_times(DT, datetime = 'datetime', threshold = '5 minutes')

# Edge list generation
edges <- edge_dist(
  DT,
  threshold = 100,
  id = 'ID',
  coords = c('X', 'Y'),
  timegroup = 'timegroup',
  returnDist = TRUE,
  fillNA = TRUE
)

## ---- eval = FALSE------------------------------------------------------------
#  # Temporal groups
#  group_times(DT, datetime = 'datetime', threshold = '5 minutes')
#  
#  # Edge list generation
#  edges <- edge_nn(
#    DT,
#    id = 'ID',
#    coords = c('X', 'Y'),
#    timegroup = 'timegroup'
#  )
#  
#  # Edge list generation using maximum distance threshold
#  edges <- edge_nn(
#    DT,
#    id = 'ID',
#    coords = c('X', 'Y'),
#    timegroup = 'timegroup',
#    threshold = 100
#  )
#  
#  # Edge list generation using maximum distance threshold, returning distances
#  edges <- edge_nn(
#    DT,
#    id = 'ID',
#    coords = c('X', 'Y'),
#    timegroup = 'timegroup',
#    threshold = 100,
#    returnDist = TRUE
#  )
#  

## ---- eval = TRUE-------------------------------------------------------------
# In this case, using the edges generated in 2. a) edge_dist
dyad_id(edges, id1 = 'ID1', id2 = 'ID2')

## ---- eval = TRUE-------------------------------------------------------------
# Get the unique dyads by timegroup
# NOTE: we are explicitly selecting only where dyadID is not NA
dyads <- unique(edges[!is.na(dyadID)], by = c('timegroup', 'dyadID'))

# NOTE: if we wanted to also include where dyadID is NA, we should do it explicitly
# dyadNN <- unique(DT[!is.na(NN)], by = c('timegroup', 'dyadID'))

# Get where NN was NA
# dyadNA <- DT[is.na(NN)]

# Combine where NN is NA
# dyads <- rbindlist(list(dyadNN, dyadNA))


# Set the order of the rows
setorder(dyads, timegroup)

## Count number of timegroups dyads are observed together
dyads[, nObs := .N, by = .(dyadID)]

## Count consecutive relocations together
# Shift the timegroup within dyadIDs
dyads[, shifttimegrp := shift(timegroup, 1), by =  dyadID]

# Difference between consecutive timegroups for each dyadID
# where difftimegrp == 1, the dyads remained together in consecutive timegroups
dyads[, difftimegrp := timegroup - shifttimegrp]


# Run id of diff timegroups
dyads[, runid := rleid(difftimegrp), by = dyadID]

# N consecutive observations of dyadIDs
dyads[, runCount := fifelse(difftimegrp == 1, .N, NA_integer_), by = .(runid, dyadID)]

## Start and end of consecutive relocations for each dyad
# Dont consider where runs aren't more than one relocation
dyads[runCount > 1, start := fifelse(timegroup == min(timegroup), TRUE, FALSE), by = .(runid, dyadID)]

dyads[runCount > 1, end := fifelse(timegroup == max(timegroup), TRUE, FALSE), by = .(runid, dyadID)]

## Example output
dyads[dyadID == 'B-H', 
      .(timegroup, nObs, shifttimegrp, difftimegrp, runid, runCount, start, end)]

