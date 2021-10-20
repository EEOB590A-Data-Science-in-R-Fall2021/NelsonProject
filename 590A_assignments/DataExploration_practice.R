# Data Exploration and Visualization practice exercise ------
# EEOB590A

# Research Question ---------
# We will be working with a dataset from an experiment where we planted seedlings near and far from conspecific adults and monitored them for survival. 
# Does survival of seedlings depend on distance from nearest conspecific adult, and does that effect vary by species or canopy openness? 

##### Data dictionary ----------
# "species"- six plant species     
# "disp" - disperser present on island - yes/no          
# "island" - island (guam, saipan, tinian, rota)     
# "site"    - 5 sites on Guam, 3 each on Rota, Tinian, Saipan         
# "fence"   - fence name (based on forest plot grid names)       
# "numalive"  - number seedlings alive in fence 
# "date"       - date fence checked     
# "observer"   - person collecting data      
# "dataentry"   - person entering data     
# "dateenter"    - date data entered    
# "uniqueidsppfence" - unique id for each spp:fence combo
# "canopydate"    - date canopy cover data taken 
# "north"          - canopy measurement 1  
# "east"           - canopy measurement 2     
# "south"            - canopy measurement 3  
# "west"             - canopy measurement 4   
# "avgcover"        -average canopy measurement (% cover)    
# "avgopen"          -average canopy measurement (% open)   
# "doubleplant"     - was this fence double planted? 
# "plantdt"          - planting data
# "dist"             - near or far from conspecific? 
# "soil"             - soil type within the fence
# "numseedplant"    - number of seedlings planted
# "DDsurvival_notes"  - notes
# "bird"             - bird presence or absence on the island
# "age"             - age of seedlings (since planting)
# "centavgopen"      - centered average open
# "adultdens_wdisp"  - adult tree density on islands with disperser for that spp
# "adultdens_wodisp" - adult tree density on islands without disperser for that spp
# "seedsize"       - seed size 
# "numtrees"        - number of conspecific trees in the plot 
# "area"            - area of the plot
# "dens_100m"       - calculated density per 100 m
# "regdens"         - density across all plots
# "regdenswd"       - density just from plots with dispersers for that species
####

# Load Libraries -----------
library(tidyverse)
library(skimr)
library(DataExplorer)

# Load Dataset ------

# Start with a tidy dataset. Load data/tidy/fencesurv_tidy.csv from the tidy folder. NA values include c("", "NA", "na"). 

# 1. Get dataset prepared for exploration ----------

# 1.1: Check structure to make sure everything is in correct class

# 1.2: If necessary, subset to the dataset you will use for the analysis
# We will use the whole dataset for now, may subset & re-run later. 

# 1.3: Make a new column for proportion alive (propalive) by dividing numalive/numseedplant 

# 1.4: Decide which variables are your response variables and which are your predictors
# Response: cbind(numalive, numseedplant) or propalive
# Continuous predictors: distance, centavgopen
# Categorical predictors: species
# Random effects: island (n=4 usually), site (n=3/island)

# 2. Data Exploration with comprehensive functions ---------
# Note anything that stands out to you from these two approaches below. 
# 2.1: Try the skim() functions from the skimr package 
# 2.2: Try the create_report() function from DataExplorer package. 

# 3. Data Exploration: Individual Variables ---------
## 3.1: Continuous variables ---------
# 3.1a: With your continuous response and predictor variables, use ggplot and geom_histogram or dotchart() to look for outliers. 

# 3.1b: With your continuous response variable, look for zero-inflation (count data only). Are there more than 25% zero's in the response? 

# 3.1c: With your continuous response variable, look for independence. 
# Are there patterns in the data that are unrelated to the fixed or random effects identified above?  Consider patterns over time, for example. 


## 3.2: Categorical variables (predictors) --------
# a) assess whether you have adequate sample size. How many observations per level of each of your categorical predictors? Are there any that have fewer than 15 observations?  

# 4. Data Exploration - Relationships between variables ------------

## 4.1: Explore relationships between your predictor variables -------
# 4.1a: look for correlation/covariation between each of your predictors (fixed & random)
#If 2 continuous predictors, use ggplot, geom_point to plot against each other, or use pairs()
#If 1 continuous and 1 categorical predictor, use ggplot with geom_boxplot() 
#For two categorical predictors, use summarize or table (ftable for more than 2 categories)

# 4.1b: Interactions: need to make sure you have adequate data for any 2-way or 3-way interactions in your model. 
## We are interested in a species * distance * centavgopen interaction. Do we have adequate sampling across this interaction? 

## 4.2: Look at relationships of Y vs X’s ---------
# See if variances are similar for each X value, identify the type of relationship (linear, log, etc.)
#plot each predictor and random effect against the response


# 5. Summary of data exploration ---------------
# Pull together all of your findings from above to summarize your general results here. This guides you on how to move forward with your analysis. 

## 5.1: Individual variables ---------
### 5.1.a: Continuous variables --------

# 5.1.a.1: Outliers (response & predictors)

# 5.1.a.2: Zero-inflation (response)

# 5.1.a.3: Independence (response)


### 5.1.b: Categorical variables ---------
# Typically categorical predictors and random effects
# 5.1.b.1: Sufficient data across all levels (island, soil, species)? Any NA's?


## 5.2. Multiple  variables -----------
# What is the relationship between variables? 
### 5.2.a: Between predictor variables ----------

# 5.2.a.1: Collinearity: No strong collinearities. Heterogeneity, though. 

# 5.2.a 2: Interactions - do we have enough data? 

### 5.2.b: Between each predictor and response ----------
# 5.2.b.1: Linearity & homogeneity- relationship of Y vs X's. 

