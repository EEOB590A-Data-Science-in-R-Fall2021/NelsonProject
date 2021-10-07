# EEOB590A Fall 2021
# Intro to R - Part 2
library(tidyverse)
## readxl library is useful for working with Excel files in R Studio


######## Topics #######
# 1. Preparing and loading data files into R
# 2. Getting to know your data
# 3. Tibbles
# 4. Using $ and square brackets
# 5. Manipulating parts of data tables

# ----- 1. Preparing and loading data files into R ------

#   Can use .csv or .txt files or excel files

# Read file using read.csv, naming it something. Note that this must be in your 
# working directory

spider <- read.csv("D:/ISU/Semester/21Fall/EEOB590A/week2/spider.csv", header = TRUE)

# You can also use use file.choose()
spider <- read.csv(file.choose())

#can also use the tidyverse approach to load CSV files
library(readr)
spidertv <- read_csv("D:/ISU/Semester/21Fall/EEOB590A/week2/spider.csv") #readr approach to loading csv's

#what are the differences? 
str(spider) # dataframe
str(spidertv) # tibble

# Reading in excel files is easy too, with readxl package. 
library(readxl)

#Use 'sheet = (fill in number)" to get the second or third sheet or whatever sheet number you want

spiderprey2 <- read_excel("D:/ISU/Semester/21Fall/EEOB590A/week2/Prey_Capture_Final_Do_Not_Touch.xlsx", sheet = 2)

## Your Turn ##

# 1) Read in the first sheet of the Prey_Capture_Final excel file. Name it something appropriate for the content. 
spiderprey1 <- read_excel("D:/ISU/Semester/21Fall/EEOB590A/week2/Prey_Capture_Final_Do_Not_Touch.xlsx")

# 2) Use the Import Dataset tool to bring in the dataset and change the classes of columns to something else (e.g. date, character etc.). Then look at the code that ran in the console below. 


# ----- 2. Getting to know your data ------

# What type of object does R interpret the spider file as? use class()
class(spider) #data.frame

# Good! R interprets it as a data frame

# Look at the dimensions - rows by cols

dim(spider) #76x12

# Look at the first rows with head()

head(spider)

# What are the column names? Row names? 

colnames(spider)
rownames(spider)

# How are the rows, columns labeled?

labels(spider)

# Summarize your data

summary(spider)

# R describes data as numerical, factors, and integers
# Use str(data) to see what it is describing your data

str(spider)

# Change class using as.factor(), as.numeric(), as.integer(), as.character()

spider$survey <- as.factor(spider$survey)

str(spider)


## YOUR TURN ## 

#Using the Spider Prey dataset, do the following: 

#1) Find out what R interprets this object as. 
class(spiderprey2) #tbl_df, tbl, data frame

#2) Determine the dimensions of the dataframe.
dim(spiderprey2) #274x12

#3) Look at the head of the dataset. How many rows does that show?
head(spiderprey2) # first 6

#4) Look at the column names and row names - are they logical? 
colnames(spiderprey2) # yes
rownames(spiderprey2) # yes

#5) Look at the summary & the structure of your dataframe. 
summary(spiderprey2)
str(spiderprey2)

#6) change the site from a character to a factor class. 
spiderprey2$site <- as.factor(spiderprey2$site)

#---------3. Tibbles ---------#
str(spider) #created using base read.csv - is a data frame
str(spidertv) #created using read_csv in tidyverse, is a tibble

#Tibbles only show the first 10 rows when you 'print' them
spider
spidertv

#Tibbles have different properties when using square brackets [,]
spider[2,3]
spidertv[2,3]


install.packages("tibble")
library(tibble)
#change data frame to tibble
as_tibble(spider)
str(spider_tb) #note that it kept all of the classes from the dataframe

#change tibble to data frame
spidertv_df <- as.data.frame(spidertv)
str(spidertv_df)


# ----- 4. Using $ and square brackets ------

# To describe cells in your data frame,
#   R uses the form data[i,j]
#   where i is row, j is column
#   Or, data$column to describe columns

# Specific cells
spider[2,5]

# Specific row
spider[2,]

# Specific column
spider[,5]

# OR, data$column

spider$island


## YOUR TURN ### 

#With the spiderprey dataset, answer the following: 

#1) What is the name of the web in the 12th row of data? 
spiderprey2[12,]

#2) Pull out all of the values in the totalprey column using 3 different approaches. 
spiderprey2$totalprey
spiderprey2[,4]
spiderprey2[[4]]


# ----- 5. Manipulating parts of data frames ------

# Create a vector by calculating
# This isnt automatically attached to the "spider" data frame
webs50m <- (spider$tot_webs/spider$length)*50

# To attach, use cbind() 
spider <- cbind(spider,webs50m)

# Make sure the new column is there
head(spider)

## YOUR TURN ###
#using the spiderprey dataset...

#1) Make a new column that sums values from obs1 to obs8. Check to see if this matches the values in totalprey column. 
sapply(spiderprey2, class)

cols.num <- c('obs8')
spiderprey2[cols.num] <- sapply(spiderprey2[cols.num],as.numeric)

spiderprey2$sum1_8 =rowSums(cbind(spiderprey2$obs1,spiderprey2$obs8),na.rm=TRUE) ## https://stackoverflow.com/questions/26046776/sum-two-columns-in-r

spiderprey2
