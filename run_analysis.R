##MY FINAL ASSIGMENT IN GETTING AND CLEANING DATA COURSE PROJECT #
setwd("C:/Users/JOvissnoel/Documents/Rproyectos/Cleaning Data/FinalProy")
library(dplyr)

### 1 Merges the training and the test sets to create one data set.####
features<-read.csv("features.txt",sep = "",col.names = c("id_feature","functions"),header = FALSE)
xtrain<-read.csv("X_train.txt",sep = "",header = FALSE,col.names = features$functions)
ytrain<-read.csv("y_train.txt",sep = "",header = FALSE, col.names = "id_activity")
xtest<-read.csv("X_test.txt",sep = "",header = FALSE, col.names = features$functions)
ytest<-read.csv("y_test.txt",sep = "",header = FALSE, col.names = "id_activity")

activ <- read.csv("activity_labels.txt",header = FALSE,sep = "",col.names = c("id", "activity"))
subject_test <- read.csv("subject_test.txt", sep = "",header = FALSE,col.names = "subject")
subject_train<- read.csv("subject_train.txt",sep = "",header = FALSE,col.names = "subject")
X<-rbind(xtrain, xtest)
Y<-rbind(ytrain, ytest)
subject<-rbind(subject_train,subject_test)
merged_data<-cbind(subject, Y, X)

### 2 Extracts only the measurements on the mean and standard deviation for each measuremen####

extracted<-merged_data%>%select(subject,id_activity, contains(c("mean","std")))

### 3 Uses descriptive activity names to name the activities in the data set ####
extracted$id_activity <-activ[extracted$id_activity, 2]
extracted<-extracted%>%rename(activity=id_activity)

### 4.  Appropriately labels the data set with descriptive variable names ####

names(extracted)<-gsub("Acc", "Accelerometer", names(extracted))
names(extracted)<-gsub("Gyro", "Gyroscope", names(extracted))
names(extracted)<-gsub("BodyBody", "Body", names(extracted))
names(extracted)<-gsub("Mag", "Magnitude", names(extracted))
names(extracted)<-gsub("^t", "Time", names(extracted))
names(extracted)<-gsub("^f", "Frequency", names(extracted))
names(extracted)<-gsub("tBody", "TimeBody", names(extracted))
names(extracted)<-gsub("-mean()", "Mean", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-std()", "STD", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-freq()", "Frequency", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("angle", "Angle", names(extracted))
names(extracted)<-gsub("gravity", "Gravity", names(extracted))


### 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

extracted_average<-extracted%>%group_by(activity,subject)%>%summarise_all(mean)

write.table(extracted_average, "FinalDataBase.txt", row.name=FALSE)



