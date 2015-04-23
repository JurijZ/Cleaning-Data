##
## run_analysis.R script does the following:
##  1 Merges the training and the test sets to create one data set.
##  2 Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3 Uses descriptive activity names to name the activities in the data set
##  4 Appropriately labels the data set with descriptive variable names. 
##  5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Use Notepad++ to browse the text files outside R

# File descriptions in the train folder:
#  X_train.txt - data file
#  y_train.txt - activities id, that are linked to the data via the row number
#  activity_labels.txt - activities description linked to the activities id in y_train.txt
#  subject_train.txt - people ids, that are linked to the data via the row number
#  
# Similar description for the files in the test folder.
# features.txt - column names

# Note: it is assumed that the dataset folder is extracted to the R home directory.
if (!file.exists(file.path("./UCI HAR Dataset"))) {
  stop("Message: Script is not able to find the 'UCI HAR Dataset' folder")
}

# _____Task 1_____
print("Executing Task 1")
# Here I read the space separated data files X_train.txt and X_test.txt.
TrainData <- read.csv(file="./UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")
TestData <- read.csv(file="./UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
#print(dim(TrainData)) # - 7352, 561
#print(dim(TestData)) # - 2947, 561

# And then I combine datasets into one:
CombinedData  <- rbind(TrainData, TestData)
#print(dim(CombinedData)) # - 10299, 561

# _____Task 2______
print("Executing Task 2")
# Column names are stored in the features.txt file
ColumnNames <- read.csv(file="./UCI HAR Dataset/features.txt", header=FALSE, sep="")
#print(dim(ColumnNames))

# I'm substituting default column names in CombinedData with the actual names
names(CombinedData) <- ColumnNames[,2]

# Now, when very column has a proper name I can select only "mean" and "std" columns:
CombinedDataMeanStd <- CombinedData[,grepl('mean\\(\\)|std\\(\\)', colnames(CombinedData))]

#______Task 3______
print("Executing Task 3")
# Lets first combine y_train and y_test activites id vectors together.
TrainActivities <- read.csv(file="./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")
TestActivities <- read.csv(file="./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")
CombinedActivities  <- rbind(TrainActivities, TestActivities)
#print(dim(CombinedActivities)) # - 10299, 1

# Also lets take activity labels
ActivityLabels <- read.csv(file="./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")

# Now I can add a Labels column to the combined activities ids vector.
# Every id will have a corresponding Label mapped
CombinedActivities$ActivityLabel <- with(CombinedActivities, ActivityLabels[V1,]$V2)

# Finally we can add a label column to the data 
# Note: the length of Dataset and Combined activites is the same
CombinedDataMeanStd$ActivityLabel <- CombinedActivities$ActivityLabel

#______Task 4______
print("Executing Task 4")
# Completed in Task 2

#______Task 5______
print("Executing Task 5")
# First we need to combine subjects from "train" and "test" into single column
# The very ame way we were doind it before, train "first" and "test" below.
TrainSubjects <- read.csv(file="./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")
TestSubjects <- read.csv(file="./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")
CombinedSubjects  <- rbind(TrainSubjects, TestSubjects)
#print(dim(CombinedSubjects)) # - 10299, 1

# Next we can add the subjects column to the data
CombinedDataMeanStd$Subject <- CombinedSubjects$V1

# By now we have everything we need collected into a single dataframe - CombinedDataMeanStd.
# Columns are named and each row has a corresponding activity/subject
# A pair of Activity/Subject uniquely identifies a subset of data.
# We need to grab each subset and calculate an average value for every column in a subset
# In other words - every processed subset will return a row of numbers,
# which we will be acumulating in the "tidy" dataframe

# It's a double 'for' loop: 
#  one 'for' - to loop throught each subject id and then nested 'for' - to loop through each activity

# I need only unique Subject values for the loop
UniqueSubjects <- unique(CombinedSubjects)
#print(UniqueSubjects$V1)

# "TidyData" dataset will be used to accumulate "tidy" dataframe
# I wanted to preserve the schema of the original dataframe,
# could not find a better option but to copy a single row :)
TidyData <- CombinedDataMeanStd[1, ]

for(subject in UniqueSubjects$V1){
  for(activity in ActivityLabels$V2){
    
    # Grabing a subset
    SubsetData  <- CombinedDataMeanStd[which(CombinedDataMeanStd$Subject == subject 
    & CombinedDataMeanStd$ActivityLabel == activity),]
    
    # Setting Subject and Activity column values to 0, this is to make colMeans() function work
    SubsetData$Subject <- 0
    SubsetData$ActivityLabel <- 0
    
    # Calculating mean value for every column
    SubsetDataAverage <- colMeans(SubsetData)
    
    # Returning Subject and ActivityLabel values to what they were
    SubsetDataAverage$Subject <- subject
    SubsetDataAverage$ActivityLabel <- activity
    
    # Adding new row of the subset mean values to the "tidy" dataset
    TidyData <- rbind(TidyData, SubsetDataAverage)
  }
}

# By the end of the loop we have a dataset of means named "TidyData".
# Now I have to remove the first row as it was used to just copy the structure of a dataframe.
TidyData = TidyData[-1,]
print(paste("The size of the TidyData table is [rows/columns]: ", nrow(TidyData), "/", ncol(TidyData))) # - size: 180, 68

#And finally I can write the rezulting table to a text file
write.table(TidyData, "./UCI HAR Dataset/TidyData.txt", sep="\t", row.names = F) 

