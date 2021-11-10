# Linear Model practice exercise

#We are going to work with a dataset on plant traits. We will test whether leaf thickness differs between tree species and island. Today, we will only do data exploration and model building/selection. We will assess model fit and interpret model results next week. 

#Helpful scripts to have open while you work on this include:  DataExplorationDay2.R, and LinearModels.R (from class today)

#Response: thickness (leaf thickness)
#Predictors: species, island
#Random effects: none for right now, but could add some later

#Load libraries (you'll need the tidyverse)
library(tidyverse)
library(ggResidpanel)
library(lmerTest)
#Load dataset (tidyREUtraits.csv) and name it "traits". 
traits <- read_csv("data/tidy/tidyREUtraits.csv")
### Part 1: explore the dataset  #######

#1. Look at structure of dataset. 
str(traits)

#2. Subset to rows that have a value for leaf thickness. How many rows did you lose? 
(traits_leaf <- traits %>%
    filter(thickness> 0))
## 776 rows were removed


#Also we will subset to the species that were collected across all three islands. I'll give you the code for this below. 
traits_sub <- traits_leaf %>%
  filter(species == "aglaia"| species == "aidia" | species == "guamia" | species == "cynometra" | species == "neisosperma" | species == "ochrosia" | species == "premna")  

## Explore single variables ##
#3. Start with continuous variables - of which we only have the response (thickness)
# a) Check for outliers
ggplot((traits_sub), aes(thickness)) + 
  geom_boxplot()

ggplot((traits_sub), aes(species)) + 
  geom_boxplot()

ggplot((traits_sub), aes(island)) + 
  geom_boxplot()


# b) Check for zero-inflation (is this relevant here?)
## Zero inflation isn't relevant here because this isn't count data. 

# c) Check for independence in the response (is each row independent?). Are there some patterns we are not including? 
## As far as I can tell each row is independent. 

mod1 <- lm(thickness ~ island, data = traits_sub)
anova(mod1)
resid_panel(mod1, plots = "all")

mod2 <- lm(thickness ~ site, data = traits_sub)
anova(mod2)
resid_panel(mod2, plots = "all")

ggplot(traits_sub, aes(island, thickness))+
  geom_boxplot()+
  facet_grid(.~site)


#4. Now categorical predictors. Do you have an adequate sample size? How many measurements per level of island and per level of species? 
## There is an adequate sample size per level of species and per levels of island. 
## There is one island*species cross that appears to be below the previously recommended 
## 15 sample size.
with(traits_sub, table(island, species))
with(traits_sub, table(species))
with(traits_sub, table(island))


## Explore relationships between variables
#5) Check for correlations between predictors, or for categorical predictors, check to see if the sampling for each species is spread across each island. This is also useful for seeing whether you have adequate samples to run an island * species interaction. Try using group_by() and count(), and then graphing it using geom_bar() and facet_grid(). 
## All species are represented at each island. 

traits_counts <- traits_sub %>%
  group_by(species, island) %>%
  summarize(n = n(), .groups = "drop")

traits_counts

ggplot(traits_counts, aes(island, n))+
  geom_point()+
  facet_grid(.~species)



#6) Look at relationships of Y vs X’s to see if variances are similar for each X value, identify the type of relationship (linear, log, etc.)
#plot each predictor and random effect against the response
## Log-linear relationship. When the response variable is logged, the results in the residual figures follow a pattern that is more expected and
## "normal" for analysis. 

traits_species <- lm(thickness ~ species, data=traits_sub)
summary(traits_species) 
resid_panel(traits_species)
resid_xpanel(traits_species)
ggplot(traits_species, aes(species, thickness))+
  geom_point()

traits_island <- lm(thickness ~ island, data=traits_sub)
summary(traits_island) 
resid_panel(traits_island)
resid_xpanel(traits_island)
ggplot(traits_island, aes(island, thickness))+
  geom_point()


### Summary of data exploration ### 
#what did you find? 
## The residuals for the log(thickness) x site and log(thickness) x island, both produce 
## residual plots that look more "normal". The distribution in the histogram tighten up and the Q-Q plot
## follows a more desirable pattern and the variability appears to be more uniform once the response variable
## is log-transformed. 


### Linear model #### 
# Create a linear model to test whether leaf thickness varies by island, and whether that depends on the plant species. 


#Option 1: Create a full model, remove interaction if not significant, but otherwise do not simplify. 
traits_mod1 <- lm(thickness ~ island + species + island*species, data=traits_sub)
anova(traits_mod1)
summary(traits_mod1)

#Option 2: Create a full model, remove any non-significant interactions to get final model. 

## Removed site*species because non-significant and inappropriate. 

#Option 3: Create a full model, and all submodels, and compare using Likelihood ratio tests (anova(mod1, mod2)) to choose the best fitting model. 
traits_mod1 <- lm(thickness ~ island + species + island*species, data=traits_sub)
traits_mod2 <- lm(thickness ~ island + species, data=traits_sub)
traits_mod3 <- lm(thickness ~ island, data=traits_sub)
traits_mod4 <- lm(thickness ~ species, data=traits_sub)
traits_null <- lm(thickness ~ 1, data=traits_sub)

anova(traits_mod1, traits_mod2)
anova(traits_mod2, traits_mod3)
anova(traits_mod3, traits_null)
anova(traits_mod4, traits_null)

## All the models are significantly better than the simplified model, therefore 
## I would select the full model (traits_mod1). 

#Option 4: Create a full model and all submodels and compare AIC values to choose the best fitting model
AIC(traits_mod1, traits_mod3, traits_mod4, traits_mod2)

## The full model (traits_mod1) has the lowest AIC value and would likely have a better fit. 

#Next week, we will assess model fit, and then interpret results. 
