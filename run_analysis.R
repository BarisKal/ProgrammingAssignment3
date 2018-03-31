#Loading libraries
library(dplyr)

#Step one
#Merges the training and the test sets to create one data set.

#Read tables
testX <- read.table(".\\test\\X_test.txt")
testY <- read.table(".\\test\\Y_test.txt")
subjectTest <- read.table(".\\test\\subject_test.txt")

trainX <- read.table(".\\train\\X_train.txt")
trainY <- read.table(".\\train\\Y_train.txt")
subjectTrain <- read.table(".\\train\\subject_train.txt")

#Merge x_test and y_test data
xdata <- rbind(testX, trainX)
#Merge x_train and y_train data
ydata <- rbind(testY, trainY)
#Merge subject_test and subject_train
subjectData <- rbind(subjectTest, subjectTrain)

#Step two
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Read features
features <- read.table(".\\features.txt")
#Grep features for mean and std
featuresMeanStd <- grep("(.*)-[Mm]ean|-[Ss]td", features[,2])
xdata <- xdata[, featuresMeanStd]
#Correct names
names(xdata) <- features[featuresMeanStd,2]

#Step three
#Uses descriptive activity names to name the activities in the data set
#Read activities
activities <- read.table(".\\activity_labels.txt")
#Set activity names
ydata[,1] <- activities[ydata[,1],2]
#Set name of table
names(ydata) <- "activity"

#Step four
#Appropriately labels the data set with descriptive variable names.
#Set name of table
names(subjectData) <- "subject"

#Merge all together
allData <- cbind(subjectData, xdata, ydata)

#Step five
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Create a new table, finalDataNoActivityType without the activityType column
total_mean <- allData %>% group_by(activity, subject) %>% summarize_each(funs(mean))

#Write tidy dataset to disk
write.table(total_mean, file = ".\\tidydata.txt", row.names = FALSE, col.names = TRUE)
