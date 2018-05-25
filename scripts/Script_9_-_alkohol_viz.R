# Pakete laden
library(tidyverse)

# Daten laden
alkohol <- read.csv(file = "/Users/LR/Dropbox/AUni/Sowi_MA/4_Sem/rvis/data/data_zeit.csv", header = TRUE, stringsAsFactors = FALSE, sep = ",", encoding = "UTF-8")

glimpse(alkohol)

alkohol <- alkohol %>% 
      gather("Spirituosen", "Rotwein", "Weißwein", "Bier", 
             key = "Getränk", 
             value = "Zustimmung"
             ) %>%
      mutate(Eigenschaft = factor(X.1, 
                                  levels = c("energiegeladen", "selbstbewusst",
                                             "entspannt", "attraktiv (sexy)",
                                             "müde", "aggressiv", "schlecht",
                                             "unruhig", "betrübt/traurig")
                                  )
             )

# Plot
ggplot(data = alkohol, 
       mapping = aes(x = X.1, y = Zustimmung, color = Getränk)) +
      geom_point(stat = "identity", size = 3) +
      coord_flip() +
      labs(y = "Zustimmung zur Gemütslage in Prozent",
           x = "", 
           caption = "Quelle: Global Drug Survey, British Medical Journal"
           ) +
      scale_color_manual(values = c("yellow2", "red","deepskyblue2", "gray")
                         ) +
      theme_minimal()

# bar chart by Getränk
ggplot(data = alkohol,
       mapping = aes(x = Eigenschaft, y = Zustimmung, fill = Getränk)) +
      geom_bar(stat = "identity", position = "dodge") +
      facet_grid(~Getränk) +
      theme(axis.text.x = element_text(angle = 20, hjust = 1))


# Unterteilung gut/schlecht
      # wie gut im durchschnitt als linie?
      # wie schlecht im durchschnitt als linie?
# schlecht: unruhig, schlecht, müde, betrübt/traurig, aggressiv
# gut: selbstbewusst, entspannt, energiegeladen, attraktiv/sexy

gut <- c("selbstbewusst", "entspannt", "energiegeladen", "attraktiv (sexy)")
bad <- c("müde", "aggressiv", "schlecht", "unruhig", "betrübt/traurig")

# Dataset for plot
p.alk <- alkohol %>% 
      mutate(gut = ifelse(X.1 %in% gut, 1,0),
             schlecht = ifelse(X.1 %in% schlecht,1,0),
             Zustimmung2 = ifelse(gut==0, Zustimmung*(-1), Zustimmung)
             ) 

# For each kind of Alkohol, how positive or negative are the effects
ggplot(data = p.alk, mapping = aes(x = Eigenschaft, y = Zustimmung2, fill = ..y.. > 0)) +
      geom_bar(stat = "identity", position = "dodge") +
      facet_grid(~Getränk) +
      scale_fill_manual(name = "Effect of Alcohol",
                        values = c('red', 'green'),
                        labels = c("negative", "positive"))+
      theme(axis.text.x = element_text(angle = 20, hjust = 1))


# For each effect, how positive or negative is each alkohol
ggplot(data = p.alk, mapping = aes(x = Getränk, y = Zustimmung2, fill = ..y.. > 0)) +
      geom_bar(stat = "identity", position = "dodge") +
      facet_grid(~Eigenschaft) +
      scale_fill_manual(name = "Effect of Alcohol",
                        values = c('red', 'green'),
                        labels = c("negative", "positive"))+
      theme(axis.text.x = element_text(angle = 20, hjust = 1))
