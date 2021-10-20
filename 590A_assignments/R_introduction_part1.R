# EEOB590A - Fall 2021
# Intro to R - Part 1
# Contributor: Jessica Nelson
# Date: 8/25/2021

######## Topics #######
# 1. Getting help
# 2. Working directories
# 3. Using R as a calculator
# 4. Creating data and variables
# 5. Functions
# 6. Downloading new packages

# ----- 1. Getting help --------
# If you know a function name, you can use
#   the question mark ? to open a help file

?mean #opens help file 
?t.test

# Help files tell possible arguments
#   and give examples at the end

help.start()  # opens the links to online manuals and miscellaneous materials

# Or, open help tab (at right) and type name in
# Or, google it! (There are great R forums)

## YOUR TURN ##
#find the help file for the function that finds the maximum of the values within a given vector or matrix
?max



# ----- 2. Working Directories ---------
# Determine your working directory

getwd()

# Set your working directory using setwd()
#   or by using "Set as working director" in the "More"
#   option in the "Files" tab on the right

setwd('D:/ISU/Semester/21Fall/EEOB590A/week1') #Why doesn't this work on your laptop?

# Working Directories & RStudio Projects
#when you are using projects, the working directory will automatically be set to the same folder as the Project. 
#If you want to access something within the project, you need to add the path to that file. 


## YOUR TURN ##
#Figure out where your working directory is currently located
"D:/ISU/Semester/21Fall/EEOB590A/CourseMaterials"

#set the working directory to your desktop (hint: can use the Session - Set working directory GUI to do this, and then see what the code is)
setwd('C:/Users/J-Nel/Desktop/')

#set the working directory back to the project directory
setwd('D:/ISU/Semester/21Fall/EEOB590A/week1')


# ----- 3. Using R as a calculator ------
1+2
cos(pi)

# Arithmetic
#  +  add
#  -  subtract
#  *  multiply
#  /  divide
#  ^  exponent

# Relational
#  >   greater, less than
#  >=  greater than or equal to
#  !=  not equal to

# Logical
#  !  not
#  &  and
#  |  or


## YOUR TURN ##
# Do some math! 
#1) There is a group of 10 people who are ordering pizza. If each person gets 2 slices and each pizza has 4 slices, how many pizzas should they order?
n = 10
people_za = 2

n / people_za

#2) Ask R whether 3.1415932 is greater than pi
3.1415932 > pi


#3) What is your age cubed? 
31^2


# ----- 4. Creating data and variables ------


# Make a vector with concatenate, c()

c(5, 7, 3, 14)

# Or save this as something

dogAges <- c(5, 7, 3, 14)

# Type the name to see it

dogAges

# Perform functions on vectors

mean(dogAges)

dogAges2 <- dogAges*2
dogAges2

# Combine vectors

dogAges <- cbind(dogAges, dogAges2)
dogAges


## YOUR TURN ##
#create a vector of the heights (in inches) of everyone in the class
ht = c(60,63,70,55,45,68,63)

# ----- 5. Functions ------

# Have form: function(argument,argument,argument,...)

# Here, curve is the function and it can interpret
#   the 2*x as the function I want to graph and
#   "from" and "to" as arguments to specify x axis length

?curve #see what the help file says

curve(2*x, from=0,to=8)


## YOUR TURN ##

#use the mean function to take the average of the heights at your table
mean(ht)

#what are the default arguments for the mean function? Include them in your code. 
?mean
mean(ht, trim = 0, na.rm=FALSE)

#Use the "trim" argument to remove 0.25 from each end of your height vector before calculating the mean. What did this do?  
mean(ht, trim = 0.25, na.rm=FALSE)

# ----- 6. Downloading new packages ------

# If the function you want is in a different package, use install.packages() (or use Packages tab in RStudio)

install.packages("lme4")

# To load this so R can use it, use library() (or check box in Packages tab on RStudio)

library(lme4)


## YOUR TURN ##
#install the tidyverse package (or really, suite of packages)
install.packages("tidyverse")

#load tidyverse
library(tidyverse)

#### Haldre - good job!
