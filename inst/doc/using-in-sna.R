## ----knitropts, include = FALSE------------------------------------------
knitr::opts_chunk$set(message = TRUE, 
                      warning = FALSE,
                      eval = FALSE, 
                      echo = TRUE)

## ------------------------------------------------------------------------
#  # Load packages
#  library(spatsoc)
#  library(data.table)
#  
#  # Read data as a data.table
#  DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))
#  
#  # Cast datetime column to POSIXct
#  DT[, datetime := as.POSIXct(datetime)]

## ------------------------------------------------------------------------
#  # Temporal groups
#  group_times(DT, datetime = 'datetime', threshold = '5 minutes')
#  
#  # Spatial groups
#  group_pts(
#    DT,
#    threshold = 50,
#    id = 'ID',
#    coords = c('X', 'Y'),
#    timegroup = 'timegroup'
#  )
#  

## ------------------------------------------------------------------------
#  # UTM zone for relocation
#  utm <- '+proj=utm +zone=36 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs'
#  
#  # Group relocations by julian day
#  group_times(DT, datetime = 'datetime', threshold = '1 day')
#  
#  # Group lines for each individual and julian day
#  group_lines(
#    DT,
#    threshold = 50,
#    projection = utm,
#    id = 'ID',
#    coords = c('X', 'Y'),
#    timegroup = 'timegroup',
#    sortBy = 'datetime'
#  )

## ------------------------------------------------------------------------
#  # Proj4 string for example data
#  utm <- '+proj=utm +zone=36 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs'
#  
#  # Option 1: area = FALSE and home range intersection 'group' column added to DT
#  group_polys(
#    DT,
#    area = FALSE,
#    hrType = 'mcp',
#    hrParams = list(percent = 95),
#    projection = utm,
#    id = 'ID',
#    coords = c('X', 'Y')
#  )
#  
#  # Option 2: area = TRUE and results must be assigned to a new variable
#  #      data.table returned has ID 1, ID 2 and proportion and area overlap
#  areaDT <- group_polys(
#    DT,
#    area = TRUE,
#    hrType = 'mcp',
#    hrParams = list(percent = 95),
#    projection = utm,
#    id = 'ID',
#    coords = c('X', 'Y')
#  )
#  

## ------------------------------------------------------------------------
#  # Iterations = 1 therefore the results are appended to DT
#  randomizations(
#     DT,
#     type = 'step',
#     id = 'ID',
#     datetime = 'timegroup',
#     iterations = 1,
#     splitBy = 'yr'
#  )

## ------------------------------------------------------------------------
#  # Calculate year column to ensure randomization only occurs within years since data spans multiple years
#  DT[, yr := year(datetime)]
#  
#  # splitBy = 'yr' to force randomization only within year
#  # Iterations > 1, results must be reassigned
#  randDaily <- randomizations(
#     DT,
#     type = 'daily',
#     id = 'ID',
#     datetime = 'datetime',
#     splitBy = 'yr',
#     iterations = 20
#  )

## ------------------------------------------------------------------------
#  # Calculate year column to ensure randomization only occurs within years since data spans multiple years
#  DT[, yr := year(datetime)]
#  
#  randTraj <- randomizations(
#     DT,
#     type = 'trajectory',
#     id = 'ID',
#     datetime = 'datetime',
#     splitBy = 'yr',
#     iterations = 20
#  )

