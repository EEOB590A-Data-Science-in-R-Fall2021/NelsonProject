#Linear Models Exercise 2

library(tidyverse)
library(lme4)
library(ggResidpanel)

#We will use the same dataset from last week

traits <- read_csv("data/tidy/tidyREUtraits.csv")

traits <- traits %>%
  filter(!is.na(thickness))

traits <- traits %>%
  filter(species == "aglaia"| species == "aidia" | species == "guamia" | species == "cynometra" | species == "neisosperma" | species == "ochrosia" | species == "premna")  

#1) Let's assess model fit for the model that came out on top for all 4 methods
thick1 <- lm(thickness ~ island*species, data = traits)

#Do data follow the assumptions of:
#1) independence?
#2) normality?
#3) constant variance?
#4) linearity?

#2) Now let's interpret the results, using each of the methods from last week: 

#Option 1: Traditional hypothesis testing (simplified model). 
#use emmeans to tell whether there are differences between islands for a given species
#which species differ between islands? 
thick1 <- lm(thickness ~ island * species, data = traits) #final model

#Option 2: Full model approach. 
#get confidence intervals using emmeans, and determine whether species differ
thick1 <- lm(thickness ~ island * species, data = traits) #final model

#Option 3: Likelihood Ratio Test approach
#use emmeans to determine whether there are differences between species across all islands
thick1 <- lm(thickness ~ island * species, data = traits) #final model

#Option 4: Create a full model and all submodels and compare AIC values to choose the best fitting model
#just interpret the best fitting model. 
thick1 <- lm(thickness ~ island * species, data = traits) #final model


