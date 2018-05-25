#####################################
####  Visa Network Data          ####
####  Data Preparation           ####
####  Fabian Gülzau              ####
####  02.10.2017                 #### 
#####################################

### Exercise: VISA NETWORK DATA
## ------------------------------------------------------ ##

## Preliminary
# Load packages that are used in the script
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, rvest, stringr, ggplot2, readxl, countrycode, gapminder, haven)

## Preparation:
# Reading in the Visa Network Data
visa <- read_xls(path = "./Visa Network Data/Visa Network Data_1969_2010.xls",
                 sheet = 2, range = "C5:FN172", col_types = c("text", rep("numeric", 167)), 
                 na = "/")

# Delete unnecessary rows and columns
visa <- visa[-1, ]
visa <- visa[ ,-2]

# Self-ties are marked as "NA" but for our purposes they should be considered as zeros.
visa[is.na(visa)] <- 0

# Rename the first column
visa <- visa %>%
      rename(Name = "Home country:")

# Cleaning of country names
visa <- visa %>%
      rename("Central African Republic" = "Central African Rep.",
             "Comoro Islands" = "Comores Islands",
             "North Korea" = "Korea (Peoples Rep.)",
             "Swaziland" = "Swasiland",
             "Kyrgyzstan" = "Kyrgystan")


# Let's transform the data frame of visa ties which by now
# is rather a matrix into a data.frame with incoming and
# outgoing ties.
## ------------------------------------------------------ ##

# How many visa waivers does every country get?
incoming <- apply(X = visa[,2:167], MARGIN = 2, sum)

# How many visa waivers do they send?
outgoing <- apply(X = visa[,2:167], MARGIN = 1, sum)

# Combine into a data.frame:
visa.df <- tbl_df(data.frame(name = colnames(visa[2:167]),
                             indegree = incoming,
                             outdegree = outgoing, 
                             stringsAsFactors = FALSE))

# We typically don't need rownames.
row.names(visa.df) <- NULL


# Load the PolityIV scores and merge them to the Visa 
# Network Data
## ------------------------------------------------------ ##

# Read the SPSS-file from http://www.systemicpeace.org/inscrdata.html
# Code Book here: http://www.systemicpeace.org/inscr/p4manualv2016.pdf
polityIV <- foreign::read.spss("http://www.systemicpeace.org/inscr/p4v2016.sav", 
                               to.data.frame = TRUE)  

# Drop some variables and filter year == 2010
polityIV <- polityIV %>%
      select(ccode, country, year, polity2) %>%
      filter(year == 2010)

# Join to visa.df
visa.df <- visa.df %>%
      mutate(ccode = countrycode(visa.df$name, "country.name.en", "p4_ccode")) %>%
      left_join(polityIV) %>% # Some missing values for Brunei, Hongkong, Iceland, Malta 
      select(-ccode, -country)


# Load the Penn World Table Data
# Data: http://www.rug.nl/ggdc/docs/pwt90.dta
# Homepage: http://www.rug.nl/ggdc/productivity/pwt/
## ------------------------------------------------------ ##

# Read the Stata file using "haven"
pwt <- haven::read_dta("http://www.rug.nl/ggdc/docs/pwt90.dta") 

# Drop some variables and filter year == 2010
pwt <- pwt %>%
      filter(year == 2010) %>%
      select(countrycode, pop, hc, cgdpe) 

# Join to visa.df
visa.df <- visa.df %>%
      mutate(iso3 = countrycode(visa.df$name, "country.name.en", "iso3c")) %>%
      left_join(pwt, by = c("iso3" = "countrycode")) %>% # Note: Warning messages are not errors!
      zap_labels() 

# Create GDP per capita (gdppc)
visa.df <- visa.df %>%
      mutate(gdppc = cgdpe / pop)


# Add the continent using "countrycode"
## ------------------------------------------------------ ##

visa.df <- visa.df %>%
      mutate(continent = countrycode(visa.df$name, "country.name.en", "continent"),
             region = countrycode(visa.df$name, "country.name.en", "region"))


# Save the Visa Network Data with its additional variables
## ------------------------------------------------------ ##

saveRDS(visa.df, file = "./Visa Network Data/data/VisaNetworkData_041017")
