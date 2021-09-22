# EEOB590A
# 22 September 2021 
# Data wrangling part 1, practice script ----------

# We will be working with a real insect pan traps dataset that I've amended 
# slightly in order to practice the skills from Monday.  
# The file is called "Data_wrangling_day1_pollination.xlsx"

# 1) Load libraries -----
# you will need tidyverse and readxl

# 2) Read in data from the InsectData tab --------

# 3) Rename columns --------
# Leave columns of insect families with capital letters, but make all other 
# column names lowercase. 
# Remove any spaces in column names. Change "location" to "site". 
# Change "tract" to "transect". 

# 4) Add missing data --------
# Note that the people who entered the data did not drag down the island or 
# location column to fill every row. Double check to make sure this worked correctly. 

# 5) Separate "Top color - Bowl color" into two different columns ------
# The first letter represents the top color and the second letter represents the 
# bowl color. We do not need to save the original column. 

# 6) Use the complete function ----------
# Check if we have data for all 3 transects at each location. 
# Do not overwrite the poll data frame when you do this. 

# Which transects appear to be missing, and why? 

# 7) Unite island, site, transect into a single column -----
# Do not add spaces or punctuation between each part. Call this column uniqueID. 
# Keep the original columns too. 

# 8) Now, make this "wide" dataset into a "long" dataset ---------
# one column should include the insect orders, and one column the number of insects. 

# 9) Just to test it out, make your "long" dataset into a "wide" one and see if anything is different. -------

# Are you getting an error? Can you figure out why? 

# 10) Join the "InsectData" with the "CollectionDates" tab ---------
# Add a collection date for each row of InsectData. You'll need to read in the
# CollectionDates tab. Play around with the various types of 'mutating joins' 
# (i.e. inner_join, left_join, right_join, full_join), to see what each one does
# to the final dataframe, and note which one you think does the job correctly. 

# 11) Create a csv with the long dataframe -------
# dataframe should include collection dates
# put new csv in the data/tidy folder

