## Coursera - Getting and cleaning data - Course Project
## Programmer: Cesar Hincapié
## Date: October 23, 2014

## The purpose of this project is to demonstrate your ability to collect, work with, 
## and clean a data set. The goal is to prepare tidy data that can be used for later 
## analysis. You will be graded by your peers on a series of yes/no questions related 
## to the project. You will be required to submit: 
## 1) a tidy data set as described below, 
## 2) a link to a Github repository with your script for performing the analysis, and 
## 3) a code book that describes the variables, the data, and any transformations or 
## work that you performed to clean up the data called CodeBook.md. 
## You should also include a README.md in the repo with your scripts. 
## This repo explains how all of the scripts work and how they are connected.

## The data linked to from the course website represent data collected from the 
## accelerometers from the Samsung Galaxy S smartphone.
## A full description is available at the site where the data was obtained: 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## You should create one R script called run_analysis.R that does the following: 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with 
##    the average of each variable for each activity and each subject.

setwd("~/Documents/Coursera/DataScience/GettingCleaningData/CourseProject")

# Check if data directory does not exist; if so, create data directory
if (!file.exists('data')) {
	dir.create('data')
}

# Download dataset zip file from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url = fileURL, destfile = './data/dataset.zip', method = 'curl')
dateDownloaded <- date()
list.files('./data')

# Read in training and test sets, and activity labels, and column bind datasets
trainingset <- read.table(file = './data/UCI HAR Dataset/train/X_train.txt')
traininglabels <- read.table(file = './data/UCI HAR Dataset/train/y_train.txt')
trainingid <- read.table(file = './data/UCI HAR Dataset/train/subject_train.txt')
trainingdata <- cbind(trainingid, traininglabels, trainingset)

testset <- read.table(file = './data/UCI HAR Dataset/test/X_test.txt')
testlabels <- read.table(file = './data/UCI HAR Dataset/test/y_test.txt')
testid <- read.table(file = './data/UCI HAR Dataset/test/subject_test.txt')
testdata <- cbind(testid, testlabels, testset)

activityLabels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Read features and substitute better feature names
features = read.table("./data/UCI HAR Dataset/features.txt")
features[, 2] = gsub('-mean', 'Mean', features[, 2])
features[, 2] = gsub('-std', 'Std', features[, 2])
features[, 2] = gsub('[-()]', '', features[, 2])

# Merge training and test sets together
allData = rbind(trainingdata, testdata)

# attach variable names to allData
names(allData) <- c('id', 'activity', features[, 2])

# Get only the data on mean and std. dev.
MeanStd <- grep(".*Mean.*|.*Std.*", features[, 2]) + 2
# Add the subject id and activity variables to MeanStd
vars_to_keep <- c(1, 2, MeanStd)
# And remove the unwanted columns from allData
allData <- allData[,vars_to_keep]
# Make allData variables names all lower case
colnames(allData) <- tolower(colnames(allData))

# make all activity labels lower case
activityLabels$V2 <- tolower(activityLabels$V2)

currentActivity <- 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

allData$activity <- as.factor(allData$activity)
allData$id <- as.factor(allData$id)

tidy <- aggregate(allData, by=list(activity = allData$activity, subject = allData$id), mean)

# Remove the id and activity columns, since a mean of those has no use
tidy[, 4] <- NULL
tidy[, 3] <- NULL
write.table(tidy, "tidy.txt", sep="\t", row.name = FALSE)