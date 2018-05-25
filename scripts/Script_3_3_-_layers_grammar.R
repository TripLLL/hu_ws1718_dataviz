
# 1. load data
nobel <- read.csv(file = "data/nobel.csv")

# Load Packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)

# 2. Wie viele beobachtungen?
dim(nobel)
str(nobel)

# 3. Welcher Zeitraum
range(nobel$year, na.rm = TRUE)

# 4. Welche Kategorien?
names(nobel)
attributes(nobel$category)

# Gibt es fehlende Werte?
anyNA(nobel)
apply(nobel, MARGIN = 2, function(x){sum(is.na(x))})
sum(sapply(nobel, is.na))

nobel %>% 
       summarize_all(function(x){sum(is.na(x))})


# Wie viele Preise insgesamt an Frauen und Männer vergeben?
nobel %>% 
      mutate(bigN = n()) %>% 
      group_by(gender) %>% 
      mutate(count_g = n()) %>% 
      mutate(freq = count_g/bigN) %>% 
      select(gender, freq) %>% 
      table()

nobel %>%
      count(gender) %>%
      mutate(prop = prop.table(n))

nobel.gender <- nobel %>% 
      filter(gender != "org") %>% 
      group_by(gender) %>% 
      summarize(count = n()) %>%          # sum(length(gender)) alternativ für n()
      mutate(sum = sum(count),
             perc = round(count/sum * 100, digits = 2))

# noch eine alternative
prop.table(table(nobel$gender), useNA = "always")

# plotting

ggplot() +
      geom_bar(data = nobel.gender, 
               mapping = aes(x = gender, y = perc),
               stat = "identity") +
      scale_y_continuous(labels = function(x){paste0(x, "%")})

# 

nobel %>% 
      filter(gender != "org") %>% 
      group_by(year, gender) %>% 
      summarize(count = n())           # sum(length(gender)) alternativ für n()

nobel %>%
      filter(gender != "org") %>% 
      count(year, gender) 


# Layers II
nobel.year <- nobel %>%
      filter(gender != "org" & !is.na(year)) %>%
      group_by(year, gender) %>%
      summarize(count = n())

#plot
ggplot(data = nobel.year, 
       mapping = aes(x = year, y = count),
       stat = "identity") +
      geom_point(aes(color = gender)) +
      geom_smooth(aes(color = gender),method = "lm") +
      geom_histogram(aes(x= year, y=count), stat= "identity", alpha = 0.1)

# liegt es an einführung neuer Kategorien?
nobel %>% 
      filter(!is.na(year)) %>%
      group_by(category) %>%
      summarise(first = min(year))

# plot insgesamte Verteilung der Preise
ggplot() +
      geom_bar(data = nobel.year, 
               mapping = aes(x = year, y = count),
               stat = "identity")
# 1943 wurde der NP für 3 Jahre wegen des Krieges nicht vergeben

nobel %>%
      filter(gender != "org") %>%
      group_by(year, gender) %>%
      summarise(count = n()) %>%
      ungroup() %>% 
      group_by(year) %>% 
      mutate(total = sum(count)) %>% 
      filter(gender = female) %>% 
      mutate(rel = count / length(gender)) %>%
      print(n = 5)

      
