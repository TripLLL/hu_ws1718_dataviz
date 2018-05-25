library(tidyverse)

dates <- as.Date(c("2017-07-07", "2017-07-17", "2017-07-01", "2017-05-14", "2017-03-06", "2017-06-30", "2017-08-17", "2017-09-24", "2017-06-16", "2017-11-20"))
rankings <- seq(from = 1, to = 10, by = 1)
descriptions <- c("G20-Gipfel",
                 "Tod von Chester Bennington",
                 "Final Fantasy XV",
                 "Landtagswahlen NRW",
                 "Doppelmord von Herne",
                 "Ehe für alle",
                 "Terroranschlag in Barcelona",
                 "Bundestagswahl",
                 "Tod Helmut Kohls",
                 "Jamaika-Aus")

facebook.topics <- tibble(date = dates,
                          description = descriptions,
                          ranking = rankings)