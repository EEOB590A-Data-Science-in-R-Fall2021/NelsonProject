# EEOB590A - Data_wrangling part 2 practice exercise ------

# Part 1: Get set up ----------
## 1.1) Load libraries ----------
library(tidyverse)
library(readxl)

## 1.2) Read in data ----------
# From the tidy folder, read in the file on pollination you created after finishing last week's assignment
pollination <- read_csv("data/tidy/dw_day1_pollination_tidy.csv")

## 1.3) Change name of columns -------
# "date traps out" should be "dateout" and and "date traps coll" should be "datecoll"
pollination <- pollination %>% 
  rename(dateout = 'date traps out',
         datecoll = 'date traps coll')

## 1.4) Change the class of each variable as appropriate ------
# Make variables into factors, numeric, character, etc. Leave the dates as is for now. 
pollination <- pollination %>%
  mutate(abundance = as.numeric(abundance)) %>% # to change class in one column
  mutate(across(c(island, site, transect, top_color, bowl_color, order), 
                as.factor)) %>% # to change multiple columns at a time

## 1.5) What format are the dates in? Change to date format ----
### already in date format


# Part 2: Fix errors within cells ------
## 2.1) Fix the levels of island and site ------
# Make sure all island and site names are in lowercase 
pollination2 <- pollination %>% 
  mutate(island = tolower(island)) %>%
  mutate(site = tolower(site))

# Rename sites: forbigrid as forbig and racetrack as race
pollination2$site[pollination2$site == 'forbigrid'] = 'forbig'
pollination2$site[pollination2$site == 'racetrack'] = 'race'
  
## 2.2) Do you see any other errors that should be cleaned up? -----
# Just good practice to do a final check on this. Insect orders should remain capitalized. 
### no I don't. Transect could be changed to lowercase, but I don't think that will make
### or break this analysis.


# Part 3: Create new columns ------
## 3.1: Create a new column for the duration of time traps were out. ------
# Make sure new column is in the numeric class. 
pollination2 <- pollination2 %>% 
  mutate(duration = as.numeric(datecoll - dateout))

## 3.2: Create a new column with just the first 5 letters of the InsectOrder ------
# Name new column order_abbrev and make sure it is a factor 
pollination2 <- pollination2 %>% 
  mutate(order_abbrev = substr(order, 1, 5))


# Part 4: Re-arrange levels of a variable and rearrange rows ------
## 4.1) Arrange levels of insectorder by average number of insects. ------ 
#this will let us create a graph later on of insect orders with the most common on one side and least common on the other side of the x-axis.
poll_sum <- pollination2 %>%
  mutate(order = fct_lump(order)) %>%
  group_by(order) %>%
  summarise(mean_count = mean(abundance, na.rm = TRUE)) %>%
  mutate(order = fct_reorder(order, mean_count))

  #ggplot(aes(x = order, y=mean_count)) +
  #geom_col()

## 4.2) Arrange entire dataset by the number of insects ------
# make these descending, so the greatest number is on row 1. 
pollination2 <- pollination2 %>% 
  arrange(desc(abundance))

# Part 5: Print tidied, wrangled database ------
# name file "poll_long_tidy.csv" and put in tidy database
write.csv(pollination2, "data/tidy/poll_long_tidy.csv", row.names=F)

