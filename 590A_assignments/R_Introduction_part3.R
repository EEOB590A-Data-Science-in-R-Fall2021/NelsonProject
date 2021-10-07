# EEOB590A Fall 2021
# Intro to R - Part 3

######## Topics #######
#1. Practice reading in Excel files, with some added complexity
#2. Learning about dates

# This script requires 2 data files: 
#"leaf damage ag expt.xls"
#"Exploring_dates.xlsx"

#Start by loading the libraries you might need (hint, need one for reading in excel files)
library(tidyverse)
library(readxl)

#1) Reading in Excel files

#We are going to work with the "leaf damage ag expt.xls" file. This is the 
#exact file I found from an undergraduate project in 2007. It's not perfect. 
#Let's see how we can fix it. 
setwd('D:/ISU/Semester/21Fall/EEOB590A/week2')

#1.a - read in the "beans" worksheet and give it the same name as the worksheet tab it came from
beans <- read_excel("leaf damage ag expt.xls")

# Look at the structure of 'beans'. What class are each of the columns in? 
beans # text, text, text, text, numeric, text, text, text, numeric, text

#Read in the beans worksheet again, and tell R the appropriate class/column type 
#for each column. Note that read_excel doesn't let you choose factor, so use text instead. Give this dataframe a new name so you can compare to earlier "beans" df. 
beans_cl <- read_excel("leaf damage ag expt.xls", col_types = c('text', 'text', 'text', 'numeric', 'numeric', 
                                                             'text', 'numeric', 'text', 'numeric', 'text'))

#Check to make sure the columns are now in the appropriate class/column type
beans_cl

#After you read it in, you realize that the "Number" column indicates the ID 
#of each exclosure, and therefore should be a factor. Change that column to a
#factor and then check to make sure it is actually a factor
beans_cl$Number <- as.character(beans_cl$Number)

#check the number of levels for this factor to make sure it converted correctly
levels(beans_cl$Number)
head(beans_cl$Number)
?levels

#1.b - Herbivory Worksheet
#read in the "herbivory" worksheet and give it the same name as the worksheet it came from
herbivory <- read_excel("leaf damage ag expt.xls", sheet = 2)

#Notice that there are some X's in the leaflet columns of the herbivory worksheet?
#Read it in again, but this time tell R that the X means NA, and give the dataframe a new  name so you can compare. 
herbivory

#Read the herbivory datasheet in again, but pull in everything but columns L and M because they do not belong with rows 2-6. If you aren't sure how to do this, look at the help file for the function that reads in excel files
herbivory <- read_excel("leaf damage ag expt.xls", sheet = 2, range = cell_cols("A:K"))

#2) Dealing with dates

#Read in the "Exploring_dates.xlsx" file. 
dates <- read_excel("Exploring_dates.xlsx")

#Is this object a vector, matrix, dataframe, tibble, array or list? 
is_tibble(dates) ## TRUE

#The name of this object is kinda unwieldy. Rename the object "dates"
dates <- read_excel("Exploring_dates.xlsx")

#What format does R recognize each of the dates as? Which ones did not read in 
#as dates? 
dates ## dttm and numeric; date4 and date6

#Create a new column based on the difference in time between date 1 and date 2 
#and name it "duration" and add it to the "dates" dataframe
str(dates_tb)

dates_tb$duration = dates_tb$date1 - dates_tb$date2
dates_tb$duration
