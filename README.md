# Getting-and-Cleaning-Data-Course-Project


# Relevant libraries:
-> Dplyr


# Scripts:

## run_analysis.R

-> Function takes in individual datasets from "UCI HAR Dataset" folder and merges them into one table. 
-> Appropriately labels the data set with descriptive variable names (based on the features table given)
-> Extracts only the measurements on the mean and standard deviation for each measurement.
-> Uses descriptive activity names to name the activities in the data set (mapped against activity label table)
-> Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Notes:

## Importing 'tidy\_data.txt' file (output file):
df <- read.table("tidy_data.txt", header = T) 

## Using CodeBook.md
Use Microsoft Word for the best viewing experience. 






