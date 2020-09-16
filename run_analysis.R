run_analysis <- function() { 

    library(dplyr)
    repo_dir <- getwd() # Get woring directory
    
    # Read in train and test dataset, features table, subject tables, and avtivity label table 
    # get data from "UCI HAR Dataset" folder 
    x_train <- read.table( paste0 (repo_dir, '/UCI HAR Dataset/train/X_train.txt')) 
    y_train <- read.table( paste0 (repo_dir, '/UCI HAR Dataset/train/y_train.txt'))
    x_test <- read.table( paste0 (repo_dir, '/UCI HAR Dataset/test/X_test.txt'))
    y_test <- read.table( paste0 (repo_dir,'/UCI HAR Dataset/test/y_test.txt'))
    subject_train <- read.table( paste0 (repo_dir,'/UCI HAR Dataset/train/subject_train.txt'))
    subject_test <- read.table( paste0 (repo_dir,'/UCI HAR Dataset/test/subject_test.txt'))
    features <- read.table( paste0 (repo_dir, '/UCI HAR Dataset/features.txt'))
    activity_label <- read.table( paste0 (repo_dir, '/UCI HAR Dataset/activity_labels.txt'))
    
    # Merge train and test datasets into one dataset
    # cbind subject identifier to train and test (using subject table) for grouping purpose in step 5 later
    train <- cbind(x_train, subject_train, y_train)
    test <- cbind(x_test, subject_test, y_test)
    full_df <- rbind(train, test) # Merged dataset
    
    # Appropriately labels the data set with descriptive variable names (based on the features table given)
    names(full_df) <- features$V2 
    
    # Extracts only the measurements on the mean and standard deviation for each measurement.
    # subsetting variables that contain "mean()" or "std()"
    extract_df <- cbind(full_df[grep("mean\\(\\)|std\\(\\)", names(full_df), ignore.case=F)], full_df[ncol(full_df)-1] ,full_df[ncol(full_df)])
    names(extract_df)[ncol(extract_df) -1] <- 'Subject_ID'
    names(extract_df)[ncol(extract_df)] <- 'ActivityName' # Assigned descriptive variable names for last two unnamed columns
    names(extract_df) <- sub('BodyBody','Body',names(extract_df),)
    
    # Uses descriptive activity names to name the activities in the data set (mapped against activity_label table)
    # map activity labels using JOIN on 'ActivityName' and "V1" (column name in activity_label table)
    extract_df <- merge(extract_df, activity_label, by.x = 'ActivityName', by.y = "V1", all.x = TRUE, all.y = FALSE)
    extract_df <- extract_df[-c(1)] # Remove old label column
    names(extract_df)[ncol(extract_df)] <- 'ActivityName' # Assign descriptive name to new label column
    
    # Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    avg_by_act_df <- extract_df %>% 
        group_by(ActivityName, Subject_ID) %>%
        summarise_all(mean) %>%
        ungroup()
    
    write.table(avg_by_act_df, file = "tidy_data.txt", row.name=FALSE) 
}
