# EEOB590A - Data_wrangling part 3 practice exercise ------
# Contributor: Jessica Nelson
# Date: 10/6/2021

# Part 1: Get set up ----------

## 1.1) Load libraries ----------
library(tidyverse)

## 1.2) Read in data ----------
# From the tidy folder, read in the file you created from last week's 
# assignment on the pollination dataset ("poll_long_tidy.csv")
pollination <- read_csv("data/tidy/poll_long_tidy.csv")

## 1.3) Change the class of each variable if needed ------
head(pollination)
# * Q1.3 ----
# didn't change any of the classes because they look OK. 

# Part 2: Subset & summarize --------

## 2.1) Make a new dataframe with just the data from Guam at the racetrack site 
# and name accordingly. --------
(poll_race <- pollination %>%
  filter(island == 'guam' & site == 'race'))
  
## 2.2) Make a new dataframe with just the uniqueID, island, site, transect, 
# insectorder, numinsects, and duration columns. --------
poll_raceSelect <- pollination %>%
  unite('uniqueID', island:site:transect, remove=FALSE)%>%
  select(uniqueID, island, site, transect, order, abundance)

## 2.3) With the full database (not the new ones you created in the two 
# previous steps), summarize data, to get: --------

### 2.3.a) a table with the total number of insects at each site, and then 
# arrange rows in descending order --------
poll_Idesc <- pollination %>%
  group_by(site) %>%
  summarise(insect_num = sum(abundance)) %>%
  arrange(desc(insect_num))

### 2.3.b) a table that shows the mean number of insects per island, arranged 
# in ascending (smallest first) order --------
poll_Imean <- pollination %>%
  group_by(site) %>%
  summarise(insect_mean = mean(abundance)) %>%
  arrange(insect_mean)

### 2.3.c) a table that shows the min and max number of insects per transect 
# (note that the transects have the same name at each site) --------
poll_transect <- pollination %>%
  unite('uniqueID', island:site:transect, remove=FALSE)%>%
  group_by(uniqueID) %>%
  summarise(min_ab = min(abundance),
            max_ab = max(abundance))

## 2.4) Figure out which insect order is found across the greatest number of 
# sites and has the most total insects --------
poll_great <- pollination %>%
  filter(abundance > 0) %>%
  group_by(order) %>%
  summarize(num_sites = n_distinct(site), 
            total_insects = sum(abundance, na.rm = TRUE)) %>%
  arrange(desc(num_sites), desc(total_insects))

## 2.5) For the insect order with the greatest total number of insects and 
# found at the most sites, calculate the mean and sd by site. Include the 
# island name in the final table. --------
poll_lepid <- pollination %>%
  filter(order == "Lepidoptera") %>%
  group_by(island, site) %>%
  summarize(avgLepid = mean(abundance, na.rm = TRUE), 
            sdLepid = sd(abundance, na.rm = TRUE)) %>%
  arrange(desc(avgLepid))

## 2.6) Ask a question about the relationship between bowl color and 
# insectorder, and then write the code to answer your question. ------
# * Q2.6 ----
# Is there a difference in insect abundance based on bowl-color recorded.
# What is the number, mean, min and max of insect per bowl-color.

poll_bowl <- pollination %>%
  filter(abundance > 0) %>%
  group_by(bowl_color) %>%
  summarize(num_order = n_distinct(order), 
            abun_insects = sum(abundance, na.rm = TRUE),
            avgOrder = mean(abundance, na.rm = TRUE), 
            minOrder = min(abundance),
            maxOrder = max(abundance))

#### Haldre- this looks great! 
