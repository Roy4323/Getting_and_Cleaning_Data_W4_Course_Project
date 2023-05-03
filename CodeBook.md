---
title: "Week4_Assignment"
author: "YOU!"
date: "2023-05-03"
output: html_document
---

**Code Book**


The final summary tidy dataset "tidydata.txt" contains the average of each variable for each activity and each subject from the Human Activity Recognition Using Smartphones Data Set

**Description**


Data in dataset contains 180 rows and 68 columns for

•mean(): Mean value

•std(): Standard deviation

**Grouping Of DATA**


The base data is grouped by the following values to build mean value and the standard deviation std()

•subject - The ID of the test subject

•activity - The type of activity performed when the corresponding measurements were taken

**Activities**


The 30 subject are numbered sequentially from 1 to 30. Activity column has 6 types as listed below.

1.WALKING

2.WALKING_UPSTAIRS

3.WALKING_DOWNSTAIRS

4.SITTING

5.STANDING

6.LAYING   ETC...

**Transformations**

The zip file containing the source data is located at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The following transformations were applied to the source data:

The training and test sets were merged to create one data set.

The measurements on the mean and standard deviation (i.e. signals containing the strings mean and std) were extracted for each measurement, and the others were discarded.
