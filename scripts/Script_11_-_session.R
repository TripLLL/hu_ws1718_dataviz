# Session 11
install_github("thomasp85/ggraph") # User/Repository (auf GitHub)
install.packages("ggalt")

library(devtools)
library(dplyr)
library(ggplot2)
library(ggalt)
library(ggraph)
library(igraph)
library(tidyverse)
library(purrr)

# Daten laden
vote.df <- readRDS(file = "./data/VoteShare")

# Einen ersten Blick
glimpse(vote.df)

# Heat Map
ggplot(data = vote.df, mapping = aes(party, land)) +
      geom_tile(mapping = aes(fill = share)) +
      scale_fill_gradient(low = "white", high = "black")

# Visa Daten laden
visa.df <- readRDS(file = "./data/VisaNetworkData_041017")

# Einen ersten Blick
glimpse(visa.df)


# lollipop
visa.df %>% 
      arrange(desc(indegree)) %>% 
      filter(name %in% c(head(name, 10), tail(name,10))) %>% 
      ggplot()  +
geom_lollipop(mapping = aes(x=reorder(name, indegree), y=indegree), horizontal = F,
              point.colour = NULL, point.size = NULL, na.rm = FALSE,
              show.legend = NA, inherit.aes = TRUE) +
      coord_flip()
      

# Daten formatierung
visa <- readRDS(file = "../data/VisaMatrix")

# (1) Matrixrepräsentation
visa.mat <- as.matrix(visa)

# (2) Netzwerkfunktionalität über "igraph"
visa.graph <- 
      igraph::graph_from_adjacency_matrix(visa.mat, 
                                          mode = "directed",
                                                  diag = FALSE, 
                                          add.colnames = TRUE)


visa.plot <- ggraph(visa.graph, layout = "kk") +     # Layout
      geom_edge_link() +                             # Edges
      geom_node_point()                              # like geom_point

visa.plot


# movie explorer shiny
# Auswahl: shiny, animation, eigene idee: 3D Plots?

data("anscombe")

x <- with(anscombe, 
          list(x1, x2, x3,x4))

y <- with(anscombe,
          list(y1, y2, y3, y4))

# Vier lineare Regressionen (Loop)
map2(.x = x, .y = y, .f = ~ lm(.y ~ .x)) 

# grafische Darstellung
scatter <- map2(.x = x, .y = y, 
                .f = ~ ggplot() +
                      geom_point(mapping = aes(x = .x, y = .y)) +
                      geom_smooth(mapping = aes(x = .x, y = .y), method = "lm", se = FALSE)
)

scatter
