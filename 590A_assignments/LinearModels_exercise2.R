#Linear Models Exercise 2

library(tidyverse)
library(lme4)
library(ggResidpanel)
library(emmeans)

#We will use the same dataset from last week

traits <- read_csv("data/tidy/tidyREUtraits.csv")

traits <- traits %>%
  filter(!is.na(thickness))

traits <- traits %>%
  filter(species == "aglaia"| species == "aidia" | species == "guamia" | species == "cynometra" | species == "neisosperma" | species == "ochrosia" | species == "premna")  

#1) Let's assess model fit for the model that came out on top for all 4 methods
thick1 <- lm(thickness ~ island*species, data = traits)

#Do data follow the assumptions of:
resid_panel(thick1)

#1) independence? ## Yes
#2) normality? ## Yes
#3) constant variance? ## Yes
#4) linearity? ## Not great. The Q-Q plot doesn't follow a linear trend at the ends suggesting the model is overpredicting. 

#2) Now let's interpret the results, using each of the methods from last week: 

#Option 1: Traditional hypothesis testing (simplified model). 
#use emmeans to tell whether there are differences between islands for a given species
#which species differ between islands? 

## All species differ between islands, but not all differences are significant. Significant differences
## exist between the following islands for a given species: 
## aglaia: guam - rota (<.0001); guam - saipan (0.0005); rota - saipan (<.0001)
## aidia: guam - rota (<.0001); guam - saipan (0.0003)
## cynometra: guam - rota (0.0076); rota - saipan (<.0001)
## guamia: guam - rota (<.0001); guam - saipan (<.0001)
## neisosperma: guam - rota (<.0001); guam - saipan (0.0003); rota - saipan (<.0001)
## ochrosia: guam - rota (<.0001); guam - saipan (<.0001)
## premna: guam - rota (<.0001); guam - saipan (<.0001); rota - saipan (0.0003)

thick1 <- lm(thickness ~ island * species, data = traits) #final model
island_means <- emmeans(thick1, pairwise ~ island|species)
island_means

#Option 2: Full model approach. 
#get confidence intervals using emmeans, and determine whether species differ
thick1 <- lm(thickness ~ island * species, data = traits) #final model
confint(island_means)$contrasts
## All species differ between islands, but not all differences are significant. Significant differences
## exist between the following islands for a given species: 
## aglaia: guam - rota (0.04523  0.082036); guam - saipan (0.01066  0.045728); rota - saipan (-0.05037 -0.020513)
## aidia: guam - rota (0.02931  0.064944); guam - saipan (0.01168  0.047319)
## cynometra: guam - rota (0.01042  0.084192); rota - saipan (-0.07769 -0.023811)
## guamia: guam - rota (0.03823  0.072640); guam - saipan (0.02501  0.059421)
## neisosperma: guam - rota (0.11193  0.156605); guam - saipan (0.01468  0.059355); rota - saipan (-0.12245 -0.072050)
## ochrosia: guam - rota (0.05731  0.094944); guam - saipan (0.04473  0.078558)
## premna: guam - rota (0.02355  0.054979); guam - saipan (0.04644  0.074686); rota - saipan (0.00848  0.034113)


#Option 3: Likelihood Ratio Test approach
#use emmeans to determine whether there are differences between species across all islands
thick1 <- lm(thickness ~ island * species, data = traits) #final model
island_means <- emmeans(thick1, pairwise ~ species)
island_means

## No significant differences in the following species across all islands: aidia - cynometra (0.9999); cynometra - guamia (0.5290)

## Significant differences in the following species across all islands: aglaia - aidia (<.0001); aglaia - cynometra (<.0001); aglaia - guamia (<.0001); aglaia - neisosperma (<.0001);
## aglaia - ochrosia (<.0001); aglaia - premna (<.0001); aidia - guamia (0.0345); aidia - neisosperma (<.0001);
## aidia - ochrosia (<.0001); aidia - premna (<.0001); cynometra - neisosperma (<.0001); cynometra - ochrosia (<.0001);
## cynometra - premna (<.0001); guamia - neisosperma (<.0001); guamia - ochrosia (<.0001); guamia - premna (<.0001);
## neisosperma - ochrosia (<.0001); neisosperma - premna (<.0001); ochrosia - premna (<.0001)

#Option 4: Create a full model and all submodels and compare AIC values to choose the best fitting model
#just interpret the best fitting model. 
thick1 <- lm(thickness ~ island * species, data = traits) #final model

## All models indicate factors and interactions are significant. The full model (traits_mod1) is the best fitting model. 

traits_mod1 <- lm(thickness ~ island + species + island*species, data=traits_sub)
traits_mod2 <- lm(thickness ~ island + species, data=traits_sub)
traits_mod3 <- lm(thickness ~ island, data=traits_sub)
traits_mod4 <- lm(thickness ~ species, data=traits_sub)
traits_null <- lm(thickness ~ 1, data=traits_sub)

AIC(traits_mod1, traits_mod3, traits_mod4, traits_mod2)


