GettingAndCleaningData_CourseProject
====================================

# Overview


This file run_analysis.R contains functions and the script to create a tidy data set for "Coursera Course Project Getting and Clean Data"
*Input* for this program is a folder "UCI HAR Dataset" that must reside in the *current working directory* and must contain the content
provided for this assignment via  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
*Output* is the file averagesPerSubjectAndActivity.txt containing the tidy data set.
The input data are measurments of movement while doing certain activities.
The output created by this program is a CSV (comma separated) file with header, no quotes. The file contains 50 columns with measurements and subject and activity.
There are 180 rows with the computed mean of a measurement for the combination of subject and activity in that row.

The program can be executed without additional parameters.

# Program Flow

## Step 1
load UCI HAR data: load test data, load train data (train/X_train.txt and test/X_test.txt).
There is a feature vector on every line, complete with subject info and activity
The label or cateogry for a feature vector can be found on the corresponding line of train/y_train.txt, and test/y_test.txt, respectively. 
These files actually use integers to represent category. 
The label is something like WALKING, STANDING. See activity_labels.txt for a complete list and the mappping of category to label (e.g. 1 == WALKING). 
The componentes of a feature vector are separated by \s+
There are 561 components, i.e. features. See features.txt for a complete list and mapping of component index to featureName.

 All  variable names are cleaned up by
removing parenthesis, hyphens and commas, and replacing them with dots where it makes sense.

Also add columns to provided context for which subject and activity the measurements were taken.
merge the loaded data into one data frame


## Step 2

Remove certain columns and keeps only those dealing with mean and standard deviation.  


## Step 3
Compute average for every variable, for every combination subject and activity

## Step 4
Output the tidy data

