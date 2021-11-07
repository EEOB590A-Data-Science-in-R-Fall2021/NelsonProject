# Data Exploration and Visualization practice exercise ------
# EEOB590A

# Research Question ---------
# We will be working with a dataset from an experiment where we planted seedlings
# near and far from conspecific adults and monitored them for survival. 
# Does survival of seedlings depend on distance from nearest conspecific adult, 
# and does that effect vary by species or canopy openness? 

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
library(ggResidpanel)
library(ggcorrplot)
install.packages('ggcorrplot')
# Load Dataset ------

# Start with a tidy dataset. Load data/tidy/fencesurv_tidy.csv from the tidy folder. NA values include c("", "NA", "na"). 

# 1. Get dataset prepared for exploration ----------
survey <- read.csv("data/tidy/fencesurv_tidy.csv") %>%
  mutate(date = as.Date(survey$date, "%m/%d/%y"),
  dateenter = as.Date(survey$dateenter, "%m/%d/%y"),
  canopydate = as.Date(survey$canopydate, "%d-%b-%y"),
  plantdt = as.Date(survey$plantdt, "%m/%d/%y"),
  propalive = numalive/numseedplant)

# 1.1: Check structure to make sure everything is in correct class
str(survey)

# 1.2: If necessary, subset to the dataset you will use for the analysis
# We will use the whole dataset for now, may subset & re-run later. 
## skip

# 1.3: Make a new column for proportion alive (propalive) by dividing numalive/numseedplant 
## piped above

# 1.4: Decide which variables are your response variables and which are your predictors
# Response: cbind(numalive, numseedplant) or propalive
# Continuous predictors: centavgopen
# Categorical predictors: species, distance
# Random effects: island (n=4 usually), site (n=3/island)





# 2. Data Exploration with comprehensive functions ---------
# Note anything that stands out to you from these two approaches below. 
# 2.1: Try the skim() functions from the skimr package 
# 2.2: Try the create_report() function from DataExplorer package. 
skim(survey)
create_report(survey)





# 3. Data Exploration: Individual Variables ---------
## 3.1: Continuous variables ---------
# 3.1a: With your continuous response and predictor variables, use ggplot and geom_histogram or dotchart() to look for outliers. 
ggplot(survey, aes(centavgopen)) + geom_boxplot()
dotchart(survey$centavgopen)
## In the dotchart output there appears to be two outliers, while the boxplot indicates 
## two "strong" outliers in addition to several observations outside of the box. 

ggplot(survey, aes(propalive)) + geom_boxplot()
dotchart(survey$propalive)
## There is no evidence of outliers based on outputs from boxplot and dotchart.

#not continuous
ggplot(survey, aes(dist, propalive)) + geom_boxplot()
## Based on figures, there appears to be no outliers in the dataset. 

#not continuous
ggplot(survey, aes(species, propalive)) + geom_boxplot()
## There are a few outliers for within the papaya and psychotria species, otherwise 
## the data looks consistent within the species predictor variable.


# 3.1b: With your continuous response variable, look for zero-inflation (count data only). Are there more than 25% zero's in the response? 
## Not applicable for propalive, because response is continuous
## duration doesn't have any zero's so not an issue here. 

# 3.1c: With your continuous response variable, look for independence. 
# Are there patterns in the data that are unrelated to the fixed or random effects identified above?  Consider patterns over time, for example. 
ggplot(survey, aes(canopydate, propalive, color=island))+
  geom_boxplot()+
  facet_grid(.~island)
## It appears there is a relationship with time and proalive variable when comparing Guam, Rota, Saipan and Tinian.
## Saipan has a different distribution regarding date and canopy date. Tinian canopied earlier than the other islands.


## 3.2: Categorical variables (predictors) --------
# a) assess whether you have adequate sample size. How many observations per level of each of your categorical predictors? Are there any that have fewer than 15 observations?  
with(survey, table(island, species))
##                              species
##island   aglaia morinda neisosperma papaya premna psychotria
##guam       40      40          32     12     40         24
##rota       24      22           0     13     24         24
##saipan     24      24          22     13     24         22
##tinian     24      21          14     15     24          0
with(survey, table(species))
##species
##aglaia     morinda neisosperma      papaya      premna  psychotria 
## 112         107          68          53         112          70 
with(survey, table(island))
##island
##guam   rota saipan tinian 
##188    107    129     98 
with(survey, table(site))
##site
##anao  chig  forb grvpt   isa  japc  ladt  mtr1 nblas nlasu palii  race  ritd sblas 
##32    37    43    40    32    39    40    46    46    22    35    38    32    40 
with(survey, table(dist))
##dist
##far near 
##268  254 

with(survey, ftable(island, species, site, dist))
## It doesn't look like there is anything fewer than 15 when each categorical variable assessed individually.
## When categorical variables are crossed, like species by island, we see many sample sizes smaller than 15.





# 4. Data Exploration - Relationships between variables ------------

## 4.1: Explore relationships between your predictor variables -------
# 4.1a: look for correlation/covariation between each of your predictors (fixed & random)
#If 2 continuous predictors, use ggplot, geom_point to plot against each other, or use pairs()
#If 1 continuous and 1 categorical predictor, use ggplot with geom_boxplot() 
#For two categorical predictors, use summarize or table (ftable for more than 2 categories)
ggplot(survey, aes(dist, centavgopen)) + 
  geom_point(size = 3)

ggplot(survey, aes(species, centavgopen, )) + 
  geom_point(size = 3)

ggplot(survey, aes(site, centavgopen, )) + 
  geom_point(size = 3)

ggplot(survey, aes(island, centavgopen)) + 
  geom_point(size = 3)

with(survey, ftable(island, species))
with(survey, ftable(island, site))
with(survey, ftable(island, dist))
with(survey, ftable(site, species))
with(survey, ftable(site, dist))
with(survey, ftable(species, dist))

##Since our predictors are categorical, we can't test this directly --> Looking at collinearity in X's


# 4.1b: Interactions: need to make sure you have adequate data for any 2-way or 3-way interactions in your model. 
## We are interested in a species * distance * centavgopen interaction. Do we have adequate sampling across this interaction? 
with(survey, ftable(centavgopen, dist, species))

## 4.2: Look at relationships of Y vs X’s ---------
# See if variances are similar for each X value, identify the type of relationship (linear, log, etc.)
#plot each predictor and random effect against the response
ggplot(survey, aes(x = dist, y= propalive)) +
  geom_point(size = 3) +
  geom_jitter()

ggplot(survey, aes(x = species, y= propalive)) +
  geom_point(size = 3) +
  geom_jitter()

ggplot(survey, aes(x = site, y= propalive)) +
  geom_point(size = 3) +
  geom_jitter()

ggplot(survey, aes(x = island, y= propalive)) +
  geom_point(size = 3) +
  geom_jitter()

ggplot(survey, aes(x = centavgopen, y= propalive)) +
  geom_point(size = 3) +
  geom_jitter() + 
  facet_grid(~site)

# 5. Summary of data exploration ---------------
# Pull together all of your findings from above to summarize your general results here. This guides you on how to move forward with your analysis. 
min(survey$centavgopen)

## 5.1: Individual variables ---------
### 5.1.a: Continuous variables --------
# 5.1.a.1: Outliers (response & predictors)
## There is only one continuous predictor in the dataset and there appears to be a couple outliers 
## when looking at the distribution of the data and relationship with the response variable.
## Before the data analysis, centavgopen variable should be logged since the range of values are spread out across
## orders of magnitude.

# 5.1.a.2: Zero-inflation (response)
## Not applicable for propalive, because response is continuous duration doesn't have any zero's so not an issue here. 

# 5.1.a.3: Independence (response)
ggplot(survey, aes(x = centavgopen, y= propalive)) +
  geom_point(size = 3) +
  geom_jitter() + 
  facet_grid(~site)
## There doesn't seem to be any patterns across sites regarding centavgopen (continuous variable)
## 'chig' has no observations. When looking at the relationship between centavgopen and propalive
## independently of other predictors, there doesn't seem to be an indepedence issue.

### 5.1.b: Categorical variables ---------
# Typically categorical predictors and random effects
# 5.1.b.1: Sufficient data across all levels (island, soil, species)? Any NA's?
## It doesn't look like there is anything fewer than 15 when each categorical variable assessed individually.
## When categorical variables are crossed, like species by island, we see many sample sizes smaller than 15.
## There are NA values in the dataset.

## 5.2. Multiple  variables -----------
# What is the relationship between variables? 
## Since our predictors are categorical, we can't test this directly --> Looking at collinearity in X's


### 5.2.a: Between predictor variables ----------

# 5.2.a.1: Collinearity: No strong collinearities. Heterogeneity, though. 

# 5.2.a 2: Interactions - do we have enough data?
## We have enough data to look at interactions among categorical predictor variables. 
## Site x species interaction has sample sizes smaller than 15, which might be too small
## to appropriately model the interaction. 

### 5.2.b: Between each predictor and response ----------
# 5.2.b.1: Linearity & homogeneity- relationship of Y vs X's. 
## Variances don't look homogenous between each predictor and response, yet
## they also don't look too bad where it would prevent an analysis from occurring. 
## I would say the dataset passes the test. 
