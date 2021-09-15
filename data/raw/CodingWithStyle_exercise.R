#Coding with Style 
#Fix this script, using good coding convention. 
#This is a made-up dataset, so you can create any story and associated meaningful variable and filenames to go with it. 
#Put this script into the format for the Outline feature in RStudio
#create dataset
df1<-data.frame(state=c('Iowa','Vermont','Hawaii','Texas','Alaska'),
                var1=c('american goldfinch','hermit thrush','nene','northern mockingbird','willow ptarmigan'),
                snow=c(1,1,0,0,1),
                catCount=sample(3:10, 5, replace=T))

#explore dataset
library(ggplot2)

ggplot(df1,aes(state,catCount))+geom_point()

#create new column
df1$max = 10

#analyze dataset
library(lme4)

mod1<-glm(snow ~ catCount, family=binomial, data=df1)
summary(mod1)

#create a csv file
write.csv(df1, "data/tidy/database1.csv")
