## ----include = FALSE----------------------------------------------------------
# the queries in this vignette use {dplyr}, and the graphs use {igraph},
# {tidygraph}, {sfnetworks} and {ggraph}, which gtfstools only suggests
has_dplyr <- requireNamespace("dplyr", quietly = TRUE)
has_igraph <- has_dplyr && requireNamespace("igraph", quietly = TRUE)
has_viz <- has_dplyr &&
  requireNamespace("tidygraph", quietly = TRUE) &&
  requireNamespace("sfnetworks", quietly = TRUE) &&
  requireNamespace("ggraph", quietly = TRUE) &&
  requireNamespace("ggplot2", quietly = TRUE)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = has_dplyr
)

Sys.setenv(OMP_THREAD_LIMIT = 2)
data.table::setDTthreads(2)


## ----warning = FALSE, message = FALSE-----------------------------------------
library(gtfstools)
library(dplyr)

# read GTFS feed
path <- system.file("extdata/poa_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(path)

# drop weekends
gtfs <- filter_by_weekday(
  gtfs,
  weekday = c("saturday", "sunday"), 
  keep = FALSE
  )

## ----warning = FALSE, message = FALSE-----------------------------------------
gtfs <- fix_gtfs(gtfs, max_speed = 25, min_dwell_time = 30)

## -----------------------------------------------------------------------------
g_gmns <- build_graph(
  gtfs, 
  from = "07:00:00", 
  to = "10:00:00", 
  format = "gmns"
  )

head(g_gmns$node)

head(g_gmns$link)

g_gmns$link |>
  dplyr::count(link_type)

## ----warning = FALSE, message = FALSE, eval = has_igraph----------------------
library(igraph)

g_igraph <- build_graph(
  gtfs, 
  from = "07:00:00", 
  to = "10:00:00", 
  format = "igraph"
  )

# get stop nodes
stop_nodes <- igraph::V(g_igraph)[node_type == "stop"]

# get travel times between stops
travel_times <- igraph::distances(
  g_igraph,
  v = stop_nodes,
  to = stop_nodes,
  mode = "out",
  weights = igraph::E(g_igraph)$travel_time
)

# travel time from one stop to itself is NA
# an `Inf` value means {igraph} found no path for a given origin-destination pair.
diag(travel_times) <- NA

## ----eval = has_igraph--------------------------------------------------------
closeness <- data.frame(
  stop_id = stop_nodes$stop_id,
  stop_name = stop_nodes$stop_name,
  closeness_from = rowMeans(1 / travel_times, na.rm = TRUE),
  closeness_to = colMeans(1 / travel_times, na.rm = TRUE)
) |>
  dplyr::mutate(closeness = (closeness_from + closeness_to) / 2)

closeness |>
  dplyr::slice_max(closeness, n = 10)

## ----eval = has_viz, message = FALSE, warning = FALSE-------------------------
library(ggplot2)
library(ggraph)
library(tidygraph)
library(sfnetworks)


## ----eval = has_viz, fig.width = 7, fig.height = 5, dpi = 96------------------
a <- build_graph(gtfs, from = "08:00:00", to = "10:00:00", format = "tidygraph")
a

ggraph(a, layout = "manual", x = x_coord, y = y_coord) +
  geom_edge_link() +
  geom_node_point()

## ----eval = has_viz-----------------------------------------------------------
net <- a |>
  tidygraph::activate("edges") |>
  dplyr::filter(link_type %in% c("in_vehicle", "transfer")) |>
  dplyr::arrange(dplyr::desc(link_type)) |>
  sfnetworks::as_sfnetwork(
    coords = c("x_coord", "y_coord"),
    crs = 4326,
    remove = FALSE,
    edges_as_lines = TRUE,
    message = FALSE
  )

net

## ----eval = has_viz, fig.width = 7, fig.height = 5, dpi = 96------------------
ggraph(net, layout = "sf") +
  geom_edge_sf(aes(colour = link_type)) +
  geom_node_sf(size = 0.5) +
  scale_edge_colour_manual(
    name = "Link type",
    values = c(in_vehicle = "#0072B2", transfer = "#D55E00"),
    labels = c(in_vehicle = "In-vehicle", transfer = "Walking transfer")
  ) +
  theme_void()

