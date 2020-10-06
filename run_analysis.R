#Getting and Cleaning Data Course Project
#created by Holly Rebelez, 2020-10-06
#used the Discussion Forums for assistance
# first download the wearable computing data from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#set the working directory - where the data is stored
setwd("C:/Users/holly/Documents/HollyCoursera/R/Getting and Cleaning Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
#read in the training data
X_train<- read.table("./train/X_train.txt")
y_train<- read.table("./train/y_train.txt")
subject_train<- read.table("./Train/subject_train.txt")
#read in the testing data
X_test<- read.table("./test/X_test.txt")
y_test<- read.table("./test/y_test.txt")
subject_test<- read.table("./test/subject_test.txt")
#read in the features file for the column names of the X_ part of the data
features<-read.table("features.txt")
features<- features[,2]
#create a list of all the columns needed for mean() and std().  This came from
# examining the features.txt file
cols_needs<- c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,
               253:254,266:271,345:350,424:429,503:504, 516:517, 529:530, 542:543)
#read in the activity labels
activity_labels<-read.table("activity_labels.txt")
activity_labels<- activity_labels[,2]
#clean up the feature (variable names)
features<-gsub("[[:punct:][:blank:]]","", features)
#row bind the training and testing primary data
X_data<-rbind(X_train, X_test)
#add the column names
colnames(X_data)<- features
#row bind the training and testing activity data and add column name
y_data<-rbind(y_train, y_test)
colnames(y_data)<- c("activity")
#row bind the training and testing subject data and add column name
subject_data<-rbind(subject_train, subject_test)
colnames(subject_data)<- c("subject")
#X_data contains the complete primary data, subset to include just needed columns
X_data_needed<-X_data[,cols_needs]
#column bind the subject, activity and needed primary data
combined_data<-cbind(subject_data, y_data, X_data_needed)
#clean up the activity numbers by adding activity names
combined_data$activity<- activity_labels[combined_data$activity]
#load dplyr for tidying data
library(dplyr)
#create a subset of the variable names to just what is being used
variable_names<- features[cols_needs]
#group the data by subject and activity and get the mean of each column
tidy_data<-group_by(combined_data, subject, activity) %>%
            summarize_each(funs(mean), variable_names) 
#write that tidy_data table
write.table(tidy_data, file="tidy_data.txt", row.name=FALSE)

#the end