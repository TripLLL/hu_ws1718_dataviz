chapter 1

devtools::install_github("kjhealy/socviz")

library(tidyverse)
library(socviz)
library(tibble)

# alt and minus make the arrow (shortcut)

# load data
url <- "https://cdn.jsdelivr.net/gh/kjhealy/viz-organdata/organdonation.csv"

organs <- read_csv(file = url)