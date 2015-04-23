# Code Book

This document describes the code inside `run_analysis.R`.

The code is organized by the project tasks:
# Initial Check
# _____Task 1_____
# _____Task 2_____
# _____Task 3_____
# _____Task 4_____
# _____Task 5_____

## Initial Check
Makes sure that the dataset files from UCI HAR are available locally in the home directory. 
Examples: ./UCI HAR Dataset

## _____Task 1_____
Merges the train and the test sets to create one data set.

Variables:
	TrainData	A Dataframe with train data
	TestData	A Dataframe with test data
	CombinedData	A Dataframe with TrainData and TestData joined one on top of another

## _____Task 2_____
Extracts only the measurements on the mean and standard deviation for each measurement. 

Variables:
	ColumnNames	A Dataframe with column labels
	CombinedDataMeanStd	A Dataframe with only columns that have mean or std in their labels
	
## _____Task 3_____
Uses descriptive activity names to name the activities in the data set

Variables:
	TrainActivities	A Vector with train dataset activity ids
	TestActivities	A Vector with test dataset activity ids
	CombinedActivities A Vector with train and test dataset activity ids joined one on top of the other
	ActivityLabels	A Dataset that holds the mapping between Activity id and the description

## _____Task 4_____
Appropriately labels the data set with descriptive variable names. 
This requirement is fulfilled by implementing Task 2.

## _____Task 5_____
From the data set in step 4, creates an independent tidy data set with the average 
of each variable for each activity and each subject. Tidy dataset is exported to the file

Variables:
	TrainSubjects	A vector of people ids for the train dataset
	TestSubjects	A vector of people ids for the test dataset
	CombinedSubjects	A vector of people ids for the combined dataset
	UniqueSubjects	A vector of unique people ids 
	TidyData	A Dataset of the final average values
	SubsetData	A Dataset of a temporary subset
	SubsetDataAverage A Dataset of a temporary subset averages
	
