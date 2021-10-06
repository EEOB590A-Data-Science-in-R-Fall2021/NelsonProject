# EEOB590A
# 22 September 2021 
# Data wrangling part 1, practice script ----------

# We will be working with a real insect pan traps dataset that I've amended 
# slightly in order to practice the skills from Monday.  
# The file is called "Data_wrangling_day1_pollination.xlsx"

# 1) Load libraries -----
# you will need tidyverse and readxl
library(tidyverse)
library(readxl)

# 2) Read in data from the InsectData tab --------
Insect <- read_excel("data/raw/Data_wrangling_day1_pollination.xlsx", sheet = 1)

##### Haldre comment: I'd probably call it insect with a lowercase I, just to save effort when typing, but that's personal preference. 

# 3) Rename columns --------
# Leave columns of insect orders with capital letters, but make all other 
# column names lowercase. 
Insect <- Insect %>% 
  rename(island = Island, 
         location = Location, 
         tract = Tract, 
         `top color - bowl color` = `Top color - Bowl color`, 
         other = Other)

# Remove any spaces in column names. Change "location" to "site". 
Insect <- Insect %>% 
  rename(site = location,
    `topcolor-bowlcolor` = `top color - bowl color`)

# Change "tract" to "transect".
Insect <- Insect %>% 
  rename(transect = tract)

colnames(Insect)

##### Haldre comment:  Looks good. Can do all of this in one chunk of code, for efficiency. 

# 4) Add missing data --------
# Note that the people who entered the data did not drag down the island or 
# location column to fill every row. Double check to make sure this worked correctly. 
insect_fill <- Insect %>%
  fill(island,site) 

# 5) Separate "Top color - Bowl color" into two different columns ------
# The first letter represents the top color and the second letter represents the 
# bowl color. We do not need to save the original column. 
insect_fill <- insect_fill %>%
  separate('topcolor-bowlcolor', c('top_color', 'bowl_color'), 
         sep='-', remove=TRUE)

# 6) Use the complete function ----------
# Check if we have data for all 3 transects at each location. 
# Do not overwrite the poll data frame when you do this. 
insect_comp <- insect_fill %>%
  complete(island,site) 

# Which transects appear to be missing, and why? 
## Guam/ForbiA/L?
## Guam/ForbiGrid/L?
## Guam/LADTA/L?
## Guam/Ladtg/L?
## Guam/LADTG/L?
## Guam/MTRL/L?
## Saipan/Anao/L?
## Saipan/Nblas/L?
## Saipan/Racetrack/L?
## Saipan/Riti/L?
## Saipan/Sblas/L?
## There may have been an issue with our assumption and use of 'fill'
## function so some island:site pairs were mismatched.

##### Haldre comment:  Yup! 

# 7) Unite island, site, transect into a single column -----
# Do not add spaces or punctuation between each part. Call this column uniqueID. 
# Keep the original columns too. 
insect_comp = insect_comp %>% unite('uniqueID', island:site:transect, remove=FALSE)

# 8) Now, make this "wide" dataset into a "long" dataset ---------
# one column should include the insect orders, and one column the number of insects. 
insect_long <- insect_comp %>%
  pivot_longer(cols = c(Diptera, Hemiptera, Coleoptera, Formicidae, Apoidea,
                        Crabronidae, Lepidoptera, Blattodea, Araneae, Isoptera,
                        Trichoptera, other, Partial), names_to = "order", values_to = "count")

# 9) Just to test it out, make your "long" dataset into a "wide" one and see if anything is different. -------
insect_wider <- insect_long %>%
  group_by(uniqueID, order) %>%
  summarise(abundance = sum(count)) %>%
  tidyr::pivot_wider(names_from = order, values_from = abundance, values_fill = 0)

# Are you getting an error? Can you figure out why? 
## Yes, there are duplicate values when we don't consider
## color as a variable to organize the dataset.

###Haldre: don't need to use "tidyr::" before pivot_wider. Only necessary if you need to clearly indicate which package a function comes from. 

# 10) Join the "InsectData" with the "CollectionDates" tab ---------
# Add a collection date for each row of InsectData. You'll need to read in the
# CollectionDates tab. Play around with the various types of 'mutating joins' 
# (i.e. inner_join, left_join, right_join, full_join), to see what each one does
# to the final dataframe, and note which one you think does the job correctly. 
collection <- read_excel("data/raw/Data_wrangling_day1_pollination.xlsx", sheet = 2)

InsectCollect_left <- insect_fill %>%
  left_join(collection, by = c("island", "site"))
# returns 480 obs of 20 variables

InsectCollect_right <- insect_fill %>%
  right_join(collection, by = c("island" = "island", "site" = "site"))
# Returns 448 obs of 20 variables

InsectCollect_inner <- insect_fill %>%
  inner_join(collection, by = c("island", "site"))
# Returns 448 observations of 20 variables

InsectCollect_full <- insect_fill %>%
  full_join(collection, (by = c("island", "site")))
# Returns 480 obs of 20 variables

# 11) Create a csv with the long dataframe -------
# dataframe should include collection dates
# put new csv in the data/tidy folder
insect_fill$site[insect_fill$site == 'Ladtg'] = 'LADTG'
insect_long <- insect_fill %>%
  pivot_longer(cols = c(Diptera, Hemiptera, Coleoptera, Formicidae, Apoidea,
                        Crabronidae, Lepidoptera, Blattodea, Araneae, Isoptera,
                        Trichoptera, other, Partial), names_to = "order", values_to = "abundance")
full <- insect_long %>%
  full_join(collection, (by = c("island", "site")))

write.csv(full, "data/tidy/dw_day1_pollination_tidy.csv", row.names=F)

### Haldre- nicely done! 
