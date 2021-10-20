# Contributor: Jessica Nelson
# Date: 9/14/2021

#Coding with Style 
#Fix this script, using good coding convention. 
#This is a made-up dataset, so you can create any story and associated meaningful variable and filenames to go with it. 
#Put this script into the format for the Outline feature in RStudio
# 1. Create dataset ----
birds <-data.frame(state=c('Iowa','Vermont','Hawaii','Texas','Alaska'),
                bird=c('american goldfinch','hermit thrush','nene','northern mockingbird','willow ptarmigan'),
                snow=c(1,1,0,0,1),
                catCount=sample(3:10, 5, replace=T))

# 2. Explore dataset ----
library(ggplot2)

ggplot(birds,aes(state,catCount))+
  geom_point()

# 3. Create new column for maximum ----
birds$max = 10

# 4. Analyze dataset ----
library(lme4)

bird_mod<-glm(snow ~ catCount, family=binomial, data=birds)
summary(bird_mod)

# 5. Create a csv file for the dataset
write.csv(birds, "data/tidy/bird_count.csv")
