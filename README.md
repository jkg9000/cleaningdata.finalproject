### Introduction

This is code related to the final project for the Coursera class, Getting and Cleaning Data.

##Here are the goals of run_analysis.R, based on this data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1. Merge the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

See CodeBook.md for a description of the steps taken

The data is assumed to be extracted (unzipped) into a parallel folder to this one, called "data/UCI HAR dataset", 
with another folder for the output, called "./data/final".  

While there are a few intermediate files (created to speed up the debugging process),
the final file is at "./data/final/finaltidy.txt"


