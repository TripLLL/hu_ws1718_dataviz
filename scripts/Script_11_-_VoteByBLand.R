# Example: Heatmap
# 17.01.2018

# Packages
if (!require("pacman")) install.packages("pacman")

p_load(tidyverse, rvest, stringr)

# Scrape
url <- "https://www.merkur.de/politik/bundestagswahl-2017-endergebnis-und-ergebnisse-aus-allen-bundeslaendern-zr-7408963.html"

# Function
scraper <- function(node){
  read_html(url) %>%
    html_nodes(node) %>%
    html_text()
}

# Loop over (nodes)
args <- list("td:nth-child(1) p", "td:nth-child(2) p")

# Run
vote <- map(args, .f = scraper)

# Create a data frame
land <- rep(c("Baden-Würtemberg", "Bayern", "Berlin", "Brandenburg",
          "Bremen", "Hamburg", "Hessen", "Mecklenburg-Vorpommern",
          "Niedersachsen", "Nordrhein-Westfalen", "Rheinland-Pfalz",
          "Saarland", "Sachsen", "Sachsen-Anhalt",
          "Schleswig-Holstein", "Thüringen"), each = 6)

vote.df <- tibble(
  land = land,
  party = vote[[1]][7:length(vote[[1]])],
  share = as.numeric(
    str_replace(
      str_extract_all(vote[[2]][7:length(vote[[2]])], pattern = "[:digit:]+,[:digit:]"),
      pattern = ",", replacement = ".")
    )
)

# Replace CDU or CSU with CDU/CSU
vote.df <- vote.df %>%
  mutate(party = str_replace(party, "(CDU)|(CSU)", "CDU/CSU"))

#saveRDS(object = vote.df, file = "C:/Users/User/HU-Box/Seafile/Meine Bibliothek/Seminare/WS 2017/Sessions/Session 10/VoteShare")
#write.csv(vote.df, file = "C:/Users/User/HU-Box/Seafile/Meine Bibliothek/Seminare/WS 2017/Sessions/Session 10/VoteShare.csv", row.names = FALSE)