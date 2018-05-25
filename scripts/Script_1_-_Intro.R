# Load packages that are used in the script
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, rvest, stringr, dplyr, tibble)

# The url of the pokedex
url <- "https://pokemondb.net/pokedex/all"

# Get the whole pokedex
pokemon <- read_html(url) %>%
      html_nodes(css = "#pokedex") %>%
      html_table() 

# Turn into a tibble (see: http://r4ds.had.co.nz/tibbles.html)
pokemon.df <- tbl_df(pokemon[[1]])

# Deal with pokemon that have dual types (package:stringr)
pokemon.df$Type1 <- str_extract(pokemon.df$Type, pattern = "([A-Z])([a-z]+)")
pokemon.df$Type2 <- str_replace(pokemon.df$Type, pattern = "([A-Z])([a-z]+)", "")

# Restrict the data set to pokémon from the early version and TV series. 
# Get a list of old pokémon names from "https://en.wikipedia.org/wiki/List_of_generation_I_Pok%C3%A9mon".
old.names <- read_html("https://en.wikipedia.org/wiki/List_of_generation_I_Pok%C3%A9mon") %>%
      html_table("#collapsibleTable0", header = TRUE, fill = TRUE)

# Get only the names
old.names <- str_trim(old.names[1][[1]]$`English name`, side = "left")[-c(1, 168)]

# Select the 'old' pokémons.
pokemon.df <- pokemon.df[which(pokemon.df$Name %in% old.names),]

# Housekeeping
rm(pokemon, url, old.names)

save(pokemon.df, file = "./Pokemon/data/PokemonData.RData")
load(pokemon.df, file = "./Pokemon/data/PokemonData")


sum(pokemon.df$Attack)
summary(pokemon.df)

lm.poke <- lm(formula = Attack ~ HP, data = pokemon.df)
summary(lm.poke)

m.Attack <- mean(pokemon.df$Attack)
med.Atk <- median(x= pokemon.df$HP)
sd.Atk <- sd(x=pokemon.df$HP)
      
??"standard deviation"

apply(pokemon.df[,4:6], MARGIN = 2, mean)


pokemon.df$piv <- pokemon.df$HP / 5
pokemon.df$ire <- pokemon.df[,4:6] / c(1,2,3)         


     # remove alles
rm(list = ls())
rm(list = setdiff(ls(), "pokemon.df"))
