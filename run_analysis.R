##############################################################################
#
# FILE
#   run_analysis.R
#
# OVERVIEW
#   Using data collected from the accelerometers from the Samsung Galaxy S 
#   smartphone, work with the data and make a clean data set, outputting the
#   resulting tidy data to a file named "tidy_data.txt".
#   See README.md for details.
#

library(dplyr)


##############################################################################
# STEP 0A - Get data
##############################################################################

# download zip file containing data if it hasn't already been downloaded
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}


##############################################################################
# STEP 0B - Read data
##############################################################################

# read training data
trainSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

# read test data
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

# read features, don't convert text labels to factors
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)
## note: feature names (in features[, 2]) are not unique
##       e.g. fBodyAcc-bandsEnergy()-1,8

# read activity labels
activity <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activity) <- c("activityId", "activityLabel")


##############################################################################
# Step 1 - Merge the training and the test sets to create one data set
##############################################################################

# concatenate individual data tables to make single data table
humanActivities <- rbind(
  cbind(trainSubjects, trainValues, trainActivity),
  cbind(testSubjects, testValues, testActivity)
)

# remove individual data tables to save memory
rm(trainSubjects, trainValues, trainActivity, 
   testSubjects, testValues, testActivity)

# assign column names
colnames(humanActivities) <- c("subject", features[, 2], "activity")


##############################################################################
# Step 2 - Extract only the measurements on the mean and standard deviation
#          for each measurement
##############################################################################

# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivities))

# ... and keep data in these columns only
humanActivities <- humanActivities[, columnsToKeep]


##############################################################################
# Step 3 - Use descriptive activity names to name the activities in the data
#          set
##############################################################################

# replace activity values with named factor levels
humanActivities$activity <- factor(humanActivities$activity, 
                                 levels = activity[, 1], labels = activity[, 2])


##############################################################################
# Step 4 - Appropriately label the data set with descriptive variable names
##############################################################################

# get column names
humanActivitiesCols <- colnames(humanActivities)

# remove special characters
humanActivitiesCols <- gsub("[\\(\\)-]", "", humanActivitiesCols)

# expand abbreviations and clean up names
humanActivitiesCols <- gsub("^f", "frequencyDomain", humanActivitiesCols)
humanActivitiesCols <- gsub("^t", "timeDomain", humanActivitiesCols)
humanActivitiesCols <- gsub("Acc", "Accelerometer", humanActivitiesCols)
humanActivitiesCols <- gsub("Gyro", "Gyroscope", humanActivitiesCols)
humanActivitiesCols <- gsub("Mag", "Magnitude", humanActivitiesCols)
humanActivitiesCols <- gsub("Freq", "Frequency", humanActivitiesCols)
humanActivitiesCols <- gsub("mean", "Mean", humanActivitiesCols)
humanActivitiesCols <- gsub("std", "StandardDeviation", humanActivitiesCols)

# correct typo
humanActivitiesCols <- gsub("BodyBody", "Body", humanActivitiesCols)

# use new labels as column names
colnames(humanActivities) <- humanActivitiesCols


##############################################################################
# Step 5 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject
##############################################################################

# group by subject and activity and summarise using mean
humanActivitiesMeans <- humanActivities %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(humanActivitiesMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)