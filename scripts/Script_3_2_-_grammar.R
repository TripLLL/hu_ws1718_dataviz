
# load data
visa.df <- readRDS(file = "data/VisaNetworkData_041017")

visa.df <- readRDS(file.choose()) # Auch möglich.

#Load Packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)


#### GGPLOT ####

##### mapping
visa.plot <- ggplot(data = visa.df, mapping = aes( x = indegree, y = gdppc)) 
str(visa.plot)

##### elements
visa.plot <- visa.plot +
      geom_point()

# visa.plot <- visa.plot + geom_path()

##### skalen
      visa.plot +
      geom_point() +
      scale_y_log10(labels = comma)

##### koordinaten
      visa.plot +
            geom_point()
      
##### statistical transformations
      # man kann die transformation auch schon vorher mit dplyr machen
      ggplot(data = visa.df,
             mapping = aes(x = indegree)) +
            geom_histogram(stat = "bin", bins = 25)
      
##### facets I / farben
      
      ggplot(data = visa.df,
             mapping = aes(x = indegree, y = gdppc)) +
            geom_point(mapping = aes(color = continent))

      ggplot(data = visa.df,
             mapping = aes(x = indegree, y = gdppc)) +
            geom_point() +
            facet_wrap(facets = ~continent)
      
#####update R
      
##### Erstellen
      
      min.troops <- read.csv(file = "https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/HistData/Minard.troops.csv",
                             stringsAsFactors = FALSE)
      
      min.city <- read.csv(file = "https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/HistData/Minard.cities.csv", 
                           stringsAsFactors = FALSE)

# man muss am anfang keine daten spezifizieren
      # aus dis von Hardley Wickham
      ggplot() +
            geom_path(data = min.troops,                     # Layer 1
                      mapping = aes(x = long, y = lat, size = survivors, color = direction, 
                                    group = group))  +
            geom_text(data = min.city,                       # Layer 2
                      mapping = aes(x = long, y = lat, label = city), size = 4)
      
