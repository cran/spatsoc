## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(spatsoc)
library(data.table)

## ---- echo = FALSE, eval = TRUE-----------------------------------------------
data.table::setDTthreads(1)

## -----------------------------------------------------------------------------
predator <- fread(system.file("extdata", "DT_predator.csv", package = "spatsoc"))
prey <- fread(system.file("extdata", "DT_prey.csv", package = "spatsoc"))

DT <- rbindlist(list(predator, prey))

# Set the datetime as a POSIxct
DT[, datetime := as.POSIXct(datetime)]


# Temporal grouping
group_times(DT, datetime = 'datetime', threshold = '10 minutes')

# Spatial grouping
group_pts(DT, threshold = 50, id = 'ID', coords = c('X', 'Y'), timegroup = 'timegroup')


# Calculate the number of types within each group
DT[, n_type := uniqueN(type), by = group]
DT[, interact := n_type > 1]

# Prey's perspective
sub_prey <- DT[type == 'prey']
sub_prey[, mean(interact)]



# Plot --------------------------------------------------------------------
# If we subset only where there are interactions
sub_interact <- DT[(interact)]

# Base R plot
plot(sub_prey$X, sub_prey$Y, col = 'grey', pch = 21)
points(sub_interact$X, sub_interact$Y, col = factor(sub_interact$type))

