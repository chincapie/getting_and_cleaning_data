# Getting and Cleaning Data: Course Project

### Introduction
This repository contains work for the course project for the Coursera course "Getting and Cleaning data".  The repo includes this README.md file, the run_analysis.R script, the tidy.txt tidy output dataset, and the CodeBook.md file. My notes follow below.

### About the raw data
The features (561 of them) are unlabeled and can be found in the X_train.txt.
The activity labels are in the y_train.txt file.
The training subjects are in the subject_train.txt file.

The same holds for the test set.

### About the script and tidy dataset
I created a script called run_analysis.R which will merge the test and training sets together and meet the requirements of the course project. The script does the following:
1. Creates a data directory to store the extracted raw data.
2. Downloads the data and reads data into R.
3. After merging training and test datasets, labels are added and only variables that have to do with mean and standard deviation are kept.
4. Finally, the script creates a tidy data set containing the average of each variable for each activity and each subject. This tidy dataset will be written to a tab-delimited file called tidy.txt, which can also be found in this repository.

### About the code book
The CodeBook.md file explains the data manipulation and cleaning performed and the resulting data and variables.
