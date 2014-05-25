
# install.packages("data.table")
library(data.table)
loadData <- function(dataSetName){
  dir <- paste("UCI HAR Dataset", dataSetName, sep="\\")
  measurementsFile <- paste(dir, paste("X_", dataSetName, ".txt", sep=""), sep="\\")
  
  print (measurementsFile )
  
  data <- read.table(measurementsFile, header = FALSE) # the input uses " " and "  ", but the default sep is whitespace, so that works
  header <- read.table("UCI HAR Dataset\\features.txt", header = FALSE)
  header <- header[, 2]
  #print(header)
  # 1 tBodyAcc-mean()-X  26 tBodyAcc-arCoeff()-X,1   486 fBodyGyro-bandsEnergy()-49,64   558 angle(tBodyGyroJerkMean,gravityMean)
  # 556 angle(tBodyAccJerkMean),gravityMean)
  # remove ()
  # replace - with .
  # replace , with .
  # tail(header)
  # gsub(pattern="\\(\\)", "!!", header)
  # tail(gsub(pattern="\\((.+)\\)", "!!\\1", header))
  
  header <- gsub(pattern="\\((.+)\\)", ".\\1", header)  #  558 
  header <- gsub(pattern="\\(\\)", "", header)  # 
  header <- gsub(pattern="-", ".", header) 
  header <- gsub(pattern=",", ".", header)
  header <- gsub(pattern="\\)", "", header) 
  
  names(data) <- header
  
  
  data <- addActivityAndSubjectColumns(data, dataSetName )

  # head (relevantData)
  return(data)
  
}


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

## input frame with measurements. This method adds info for which s and a measures were taken
addActivityAndSubjectColumns <- function(data, dataSetName)
{
  
  dir <- paste("UCI HAR Dataset", dataSetName, sep="\\")
  activitiesFile <- paste(dir, paste("y_", dataSetName, ".txt", sep=""), sep="\\")
  subjectsFile <- paste(dir, paste("subject_", dataSetName, ".txt", sep=""), sep="\\")
  
  
  activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt", header = FALSE)
  activityLabels <- activityLabels[[2]]  # originally this has class data.frame. the [[]] allow getting a proper vector, wheras [] is a data.frame again
  
  
  activities <- read.table(activitiesFile, header = FALSE)
  activities <- activities[[1]]
  
  subjects <- read.table(subjectsFile, header = FALSE)
  subjects <- subjects[[1]]
  
  #nrow(data)
  #nrow(activities)
  
  
  
  # add activity column
  activity <- factor(activities, levels = c(1,2,3,4,5,6), labels = activityLabels)
  data["activity"] = activity
  
  # add subject column
  subject <- subjects # for naming of column
  
  data["subject"] = subject
 
  return(data)
}  
  


# load test data, load train data 

# put all columns into one table, add one column to keep track of source (train or test )


# Read feature vectors for train and test dataset (train/X_train.txt and test/X_test.txt)
# There is a feature vector on every line 
# The label or cateogry for a feature vector can be found on the corresponding line of train/y_train.txt, and test/y_test.txt, respectively. 
# These files actually use integers to represent category. 
# The label is something like WALKING, STANDING. See activity_labels.txt for a complete list and the mappping of category to label (e.g. 1 == WALKING). 


# The componentes of a feature vector are separated by \s+
# There are 561 components, i.e. features. See features.txt for a complete list and mapping of component index to featureName.

#########
########
######
testData <- loadData("test")
trainData <- loadData("train")
mergedData <- rbind(testData, trainData)
#mergedData <- testData



# task 2
data <- extractMeansAndStandardDeviation(mergedData)



data <- data.table(data)

d <- data[, lapply(.SD, mean), by = c("activity", "subject")]


write.table(d, "averagesPerSubjectAndActivity.txt", sep=",", row.names = F, quote=FALSE)


# names(d)
