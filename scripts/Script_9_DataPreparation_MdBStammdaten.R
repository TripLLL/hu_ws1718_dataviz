# Stammdaten Bundestagsmitglieder
# Source: https://www.bundestag.de/service/opendata
# Date: 05.12.2017
# Author: Fabian Gülzau

# Das Dokument zeigt die `grobe` Datenaufbereitung der Stammdaten des Deutschen Bundestages. 
# Am Ende steht der Datensatz zur WP 18 (2013-2017), der im Seminar Verwendung findet. Der
# Code ist weitestgehend unkommentiert. Ich stelle ihn nur für Interessierte online. 

# Load packages
if (!require("pacman")) install.packages("pacman")
p_load(tidyverse, XML, listviewer)


# Data Preparation (run only once)
# --------------------------------------------------- #
# Read data (data comes from: https://www.bundestag.de/service/opendata)
mdb.xml <- xmlParse("C:\\Users\\User\\Downloads\\mdb-stammdaten-data\\MDB_STAMMDATEN.xml")
mdb.root <- xmlRoot(mdb.xml)

# XML as list
xml.list <- xmlToList(mdb.xml, node = "//MDB") # large > 50mb, takes minutes

# Save the result as rds
# saveRDS(object = xml.list, file = "./MDB/MDB")


# Saved Data 
# --------------------------------------------------- #
# Read the data from hard drive
mdb.list <- readRDS(file = "./MDB/MDB")

# The first list only contains the version number and can be discarded
mdb.list <- mdb.list[2:3811]

# Have a look at the structure of the list
str(mdb.list, max.level = 4, list.len = 2)
# Also:
listviewer::jsonedit(listdata = mdb.list)


# Extract elements (there must be a better way)
# --------------------------------------------------- #

# (1) ID
ID <- vector(mode = "list", length = length(mdb.list))
for (i in seq_along(mdb.list)) {
  ID[[i]] <- mdb.list[i]$MDB$ID
}

# vector
ID <- purrr::flatten_chr(ID)

# Name
name <- vector(mode = "list", length = length(mdb.list))
for (i in seq_along(mdb.list)) {
  name[[i]] <- mdb.list[i]$MDB$NAMEN$NAME[c(1, 2)]
}

# vector
surname <- map_chr(name, "NACHNAME")
firstname <- map_chr(name, "VORNAME")

# Biografische Angaben
bio <- vector(mode = "list", length = length(mdb.list))
for (i in seq_along(mdb.list)) {
  bio[[i]] <- mdb.list[i]$MDB$BIOGRAFISCHE_ANGABEN[c(1, 2, 5, 9)]
}

bio <- bio %>%
  tibble(
    birth = map_chr(., "GEBURTSDATUM", .null = NA_character_),
    birthplace = map_chr(., "GEBURTSORT", .null = NA_character_),
    gender = map_chr(., "GESCHLECHT", .null = NA_character_),
    party.short = map_chr(., "PARTEI_KURZ", .null = NA_character_)
  )

bio <- bio[,-1]

# Wahlperiode
election <- vector(mode = "list", length = length(mdb.list))
for (i in seq_along(mdb.list)) {
  last <- length(mdb.list[i]$MDB$WAHLPERIODEN)
  election[[i]] <- mdb.list[i]$MDB$WAHLPERIODEN[last]$WAHLPERIODE[c(1, 2)]
}

election.df <- election %>%
  tibble(
    period = map_chr(., "WP"),
    from = map_chr(., "MDBWP_VON")
  )

# Housekeeping
rm(i, last)

# Turn into a data frame
# --------------------------------------------------- #

mdb.df <- tibble(
  ID = ID,
  firstname = firstname,
  surname = surname,
  birth = bio$birth,
  birthplace = bio$birthplace,
  gender = bio$gender,
  party = bio$party.short,
  election.last = election.df$period,
  election.from = election.df$from,
  formation = "22.10.2013"
)

# Housekeeping
rm(list = setdiff(ls(), "mdb.df"))

# Working with the data
# --------------------------------------------------- #
mdb18.df <- mdb.df %>%
  filter(election.last == 18 & election.from == "22.10.2013" & party != "Plos") %>%
  mutate(birth = strtoi(stringr::str_extract_all(birth, pattern = "[:digit:]{4}")),
         formation = strtoi(stringr::str_extract_all(formation, pattern = "[:digit:]{4}")),
         age = formation - birth)

# saveRDS(object = mdb18.df, file = "./MDB/mdb18")
# mdb18.df <- readRDS(file = "./MDB/mdb18")