## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  echo = TRUE,
  comment = "#>"
)

## ----eval = TRUE--------------------------------------------------------------
## Load packages
library(spatsoc)
library(data.table)

## ----echo = FALSE, eval = TRUE------------------------------------------------
data.table::setDTthreads(1)

## ----eval = TRUE--------------------------------------------------------------
## Read data as a data.table
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

## Cast datetime column to POSIXct
DT[, datetime := as.POSIXct(datetime)]

## ----eval = TRUE--------------------------------------------------------------
# Temporal groups
group_times(DT, datetime = 'datetime', threshold = '5 minutes')

# Edge-list generation
edges <- edge_dist(
  DT,
  threshold = 100,
  id = 'ID',
  coords = c('X', 'Y'),
  timegroup = 'timegroup',
  returnDist = TRUE,
  fillNA = TRUE
)

## ----eval = FALSE-------------------------------------------------------------
# # Temporal groups
# group_times(DT, datetime = 'datetime', threshold = '5 minutes')
# 
# # Edge-list generation
# edges <- edge_nn(
#   DT,
#   id = 'ID',
#   coords = c('X', 'Y'),
#   timegroup = 'timegroup'
# )
# 
# # Edge-list generation using maximum distance threshold
# edges <- edge_nn(
#   DT,
#   id = 'ID',
#   coords = c('X', 'Y'),
#   timegroup = 'timegroup',
#   threshold = 100
# )
# 
# # Edge-list generation using maximum distance threshold, returning distances
# edges <- edge_nn(
#   DT,
#   id = 'ID',
#   coords = c('X', 'Y'),
#   timegroup = 'timegroup',
#   threshold = 100,
#   returnDist = TRUE
# )
# 

## ----eval = TRUE--------------------------------------------------------------
# In this case, using the edges generated in 2. a) edge_dist
dyad_id(edges, id1 = 'ID1', id2 = 'ID2')

## ----eval = TRUE--------------------------------------------------------------
fusion_id(
  edges = edges,
  threshold = 100,
  n_min_length = 1,
  n_max_missing = 0,
  allow_split = FALSE
)

# Print first 10 fusion events
print(edges[fusionID <= 5])

