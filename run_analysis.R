
# headers for the data set

feature_names = read.table('features.txt')
head(feature_names)

# read files

testX <- read.table('test/X_test.txt')
head(testX)
dim(testX)

testY <- read.table('test/Y_test.txt')
head(testY)
dim(testY)

subject <- read.table('test/subject_test.txt')
head(subject)
dim(subject)

trainX <- read.table('train/X_train.txt')
head(trainX)
dim(trainX)

trainY <- read.table('train/Y_train.txt')
head(trainY)
dim(trainY)

subjectTrain <- read.table('train/subject_train.txt')
head(subjectTrain)
dim(subjectTrain)

# give column names to subject files
names(subject) <- "subjectID"
names(subjectTrain) <- "subjectID"

# assign column names
feature_names = read.table('features.txt')
head(feature_names)
names(trainX) <- feature_names$V2
names(testX) <- feature_names$V2

names(trainY) <- "activity"
names(testY) <-  "activity"

#Merges the training and the test sets to create one data set.
train <-cbind(subjectTrain,trainX,trainY)
test <- cbind(subject,testX,testY)

head(train)

mergeData <- rbind(train,test)
head(mergeData,2)
# Extracts only the measurements on the mean and standard deviation for each measurement.
extractData <- grepl("mean\\(\\)",names(mergeData)) | grepl("std\\(\\)",names(mergeData))
head(extractData,9)

#Uses descriptive activity names to name the activities in the data set
mergeData$activity

install.packages("dplyr")
library(dplyr)
factor(mergeData$activity)
mergeData$activity <- factor(mergeData$activity,labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
head(mergeData$activity,9)

#From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
install.packages("reshape2")
library(reshape2)
meltedData <- melt(mergeData, id=c("subjectID","activity"))
tidyData <- dcast(meltedData, subjectID+activity ~ variable, mean)

write.table(tidyData,"tidyData.txt",row.names = FALSE)
