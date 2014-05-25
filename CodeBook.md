CodeBook
========

# General

This CodeBook describes the raw and tidy data sets about wearable computing. The tidy data set consists of 50 variables with 180 observations each.

# Raw Data
The raw data that serves as input for my script run_analysis.R can be obtained here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


A full description is available here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

 
# Study Design
The tidy data set created by running run_analysis.R contains 50 variables. It contains 
	- all raws variables that contain ".std." or ".mean." in their name
	- subject: id of study participant
	- activity: name of activty for which the raw variables were measured

I selected the std and mean variables from the the original measurements omitted derived values.

The values of the variables in the tidy data set is an average of the raw data variables.
These variables are:
The measurements themselves with two separate values for mean and standard deviation summarizing a time window. Each with separate columns for X, Y, Z components.
- time domain measurements (t...):  tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
- frequency domain measurements (f...): fBodyAcc, fBodyAccJerk, fBodyGyro

The values are normalized and bounded within [-1,1].
Also available as columns:

- activity and subject
to give the context for the measurements, what was measured and for which subject.

# Transformations
To transform the raw data set to a tidy data set, run_analysis.R performs the following transformations


## Step 1
From the train and test directory the X, y and subject files are read. They are merged into a single data frame. The resulting data frame consists of the subject, the activity and the 561 features that are described in UCI HAR Dataset/features.info
The names of the variables as found in the raw set are renamed as follows: parentheses, commas and dashes are removed and replaced with dots.

## Step 2
The number of variables is reduced. Only those variables that contain "std" or "mean" in their name are kept.

## Step 3
The data is summarized. For every variable the average is computed per subject and activity.


