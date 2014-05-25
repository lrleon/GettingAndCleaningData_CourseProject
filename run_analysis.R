
### This file contains functions and the script to create a tidy data set for "Coursera Course Project Getting and Clean Data"
### Input for this script is a folder "UCI HAR Dataset" that must reside in the current working directory and must contain the content
### provided for this assignment via  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
### The input data are measurments of movement while doing certain activities
### The output created by this program is a CSV (comma separated) file with header, no quotes.
library(data.table)

# This Funktion loads UCI HAR data and returns a data frame. The given dataSetName can be one of "test" or "train"
# The returned df contains columns subject, activity and a column for every measurement. The variable names are cleaned up by
# removing parenthesis, hyphens and commas, and replacing them with dots where it makes sense.
loadData <- function(dataSetName){
  dir <- paste("UCI HAR Dataset", dataSetName, sep="\\")
  measurementsFile <- paste(dir, paste("X_", dataSetName, ".txt", sep=""), sep="\\")
  
  
  # read variable names for the measurements
  header <- read.table("UCI HAR Dataset\\features.txt", header = FALSE)
  header <- header[, 2]
  
  ## The variable names need to be cleaned up. The following are examples of what we are dealing with:
  # 1 tBodyAcc-mean()-X  26 tBodyAcc-arCoeff()-X,1   486 fBodyGyro-bandsEnergy()-49,64   558 angle(tBodyGyroJerkMean,gravityMean)
  # 556 angle(tBodyAccJerkMean),gravityMean)
  
  # make pretty variable names...
  header <- gsub(pattern="\\((.+)\\)", ".\\1", header)  #  for 558 
  header <- gsub(pattern="\\(\\)", "", header)
  header <- gsub(pattern="-", ".", header) 
  header <- gsub(pattern=",", ".", header)
  header <- gsub(pattern="\\)", "", header) # for 556
  
  
  ## read the actual measurements
  data <- read.table(measurementsFile, header = FALSE) #  Note: the input uses " " and "  ", but the default sep is whitespace, so that works
  names(data) <- header
  
  ## The measurements only makes sense together within the context of "subject doing activity". Here we add this info as new columns
  data <- addActivityAndSubjectColumns(data, dataSetName )

  return(data)
}

# This function removes certain columns and keeps only those dealing with mean and standard deviation.  
extractMeansAndStandardDeviation <- function(data)
{
  header <- names(data)
  measurementsMeans = grepl("\\.mean\\.", header)
  measurementsStdDeviations = grepl("\\.std\\.", header)
  subjectAndActivity = grepl("subject", header) | grepl("activity", header)

   selectColumns <- measurementsMeans | measurementsStdDeviations | subjectAndActivity
  
  relevantData <- data[, which(selectColumns)]
  return(relevantData)
  
}

## This function loads activities and subject information to provide context for measurements. Data is loaded from the given dataSetName, 
# one of "test" or "train". This information is then
# added to the given data frame as new columns. Therefore the order of the rows must match the line order of the raw data file
# input frame with measurements. This method adds info for which subject and activity measures were taken
addActivityAndSubjectColumns <- function(data, dataSetName)
{
  # create file names
  dir <- paste("UCI HAR Dataset", dataSetName, sep="\\")
  activitiesFile <- paste(dir, paste("y_", dataSetName, ".txt", sep=""), sep="\\")
  subjectsFile <- paste(dir, paste("subject_", dataSetName, ".txt", sep=""), sep="\\")
  
  
  # load names for the numeric activity identifiers
  activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt", header = FALSE)
  activityLabels <- activityLabels[[2]]  # originally this has class data.frame. the [[]] allow getting a proper vector, wheras [] is a data.frame again
  
  # load the actual activity data 
  activities <- read.table(activitiesFile, header = FALSE)
  activities <- activities[[1]]
  
  # load subject identifiers
  subjects <- read.table(subjectsFile, header = FALSE)
  subjects <- subjects[[1]]

  # Create new column with activities. This is done by means of a factor that maps to the the proper labels
  activity <- factor(activities, levels = c(1,2,3,4,5,6), labels = activityLabels)

  # add new columns to given input with measurements
  data["activity"] = activity
  data["subject"] = subjects
 
  return(data)
}  
  


###
### The main program of run_analysis.R 
###




#########
########
######

### Step 1
## load test data, load train data (train/X_train.txt and test/X_test.txt).
# There is a feature vector on every line, complete with subject info and activity
# The label or cateogry for a feature vector can be found on the corresponding line of train/y_train.txt, and test/y_test.txt, respectively. 
# These files actually use integers to represent category. 
# The label is something like WALKING, STANDING. See activity_labels.txt for a complete list and the mappping of category to label (e.g. 1 == WALKING). 
# The componentes of a feature vector are separated by \s+
# There are 561 components, i.e. features. See features.txt for a complete list and mapping of component index to featureName.

testData <- loadData("test")
trainData <- loadData("train")
mergedData <- rbind(testData, trainData)



### Step 2 
# task2: remove some columns and keep only those measurements dealing with mean and standard deviation
data <- extractMeansAndStandardDeviation(mergedData)

### Step 3: compute means
# just to use the more powerful data.table functionality .SD=="subset of a data table" ...
data <- data.table(data) 

# ... to compute the mean per subject and activity
d <- data[, lapply(.SD, mean), by = c("activity", "subject")]


### output the tidy data
write.table(d, "averagesPerSubjectAndActivity.txt", sep=",", row.names = F, quote=FALSE)


### End of Program 
###







# my notes
# Codebook, see "Components of tidy data" 4:30min
# names(d)
