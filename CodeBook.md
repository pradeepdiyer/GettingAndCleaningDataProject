###Pradeep Iyer###

#Getting and Cleaning Data Project#

For this project is a tidy data set is prepared that can be used for later analysis. The collected data is tidied up using the run_analysis function in the run_analysis.R file.

**The R script called run_analysis.R does the following:**

Merges the training and the test sets to create one data set.

Extracts only the measurements on the mean and standard deviation 
for each measurement. 

Uses descriptive activity names to name the activities in the data set

Appropriately labels the data set with descriptive variable names. 

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
##Source Data##

NOTE: the run_analysis function assumes you have the UCI HAR Data set downloaded and unzipped in the working directory.

A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones][1]

Here are the data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip][2]

##Description of the DATA##

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. and the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) - both using a low pass Butterworth filter.

The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).
Description of abbreviations of measurements

leading t or f is based on time or frequency measurements.

Body = related to body movement.

Gravity = acceleration of gravity

Acc = accelerometer measurement

Gyro = gyroscopic measurements

Jerk = sudden movement acceleration

Mag = magnitude of movement

mean and SD are calculated for each subject for each activity for each mean and SD measurements.

The units given are g's for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag
    

The set of variables that were estimated from these signals are:

mean(): Mean value

std(): Standard deviation

##Data Set Information:##

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##The run_analysis function does the following:##
*This script assumes the UCI HAR Dataset is unzipped in the working directory.*
Also, print commands have been indluded so that the user is notified of the progress.

**Loads the necessary packages.**

  library(data.table)

  library(dplyr)

  working_directory <- getwd()
  
**Reads all the necessary data files**

  print("Reading all the necessary data files")

  Features <- read.table(file.path(working_directory, "UCI HAR Dataset", "features.txt"))

  Activity_Labels <- read.table(file.path(working_directory, "UCI HAR Dataset", "activity_labels.txt"))
  
  Train_Subject <- read.table(file.path(working_directory, "UCI HAR Dataset", "train", "subject_train.txt"))

  Train_Activity_Num <- read.table(file.path(working_directory, "UCI HAR Dataset", "train", "y_train.txt"))

  Train_Data <- read.table(file.path(working_directory, "UCI HAR Dataset", "train", "X_train.txt"))
  
  Test_Subject <- read.table(file.path(working_directory, "UCI HAR Dataset", "test", "subject_test.txt"))

  Test_Activity_Num <- read.table(file.path(working_directory, "UCI HAR Dataset", "test", "y_test.txt"))

  Test_Data <- read.table(file.path(working_directory, "UCI HAR Dataset", "test", "X_test.txt"))
  
**Merges the training and test data sets**

  print("Merging training and test data sets")

  Combined_Subject <- rbind(Train_Subject, Test_Subject)

  Combined_Activity_Num <- rbind(Train_Activity_Num, Test_Activity_Num)

  Combined_Data <- rbind(Train_Data, Test_Data)

  All_Combined_Data <- cbind(Combined_Subject, Combined_Activity_Num, Combined_Data)
  
**Names the coulmns according to features.txt**

print("Naming the coulmns according to features.txt")

  names(All_Combined_Data)[1]<-"Subject"

  names(All_Combined_Data)[2]<-"Activity_Num"

  setnames(All_Combined_Data, names(All_Combined_Data), c("Subject","Activity_Num",as.character(Features$V2)))
  
**Sets the Activity labels**

  print("Setting the Activity labels")

  setnames(Activity_Labels, names(Activity_Labels), c("Activity_Num", "Activity"))

  All_Combined_Data <- merge(Activity_Labels, All_Combined_Data, by="Activity_Num", all.x=TRUE)
  
**Filtering out the column names that have mean and std in the names**

  print("Keeping only the column names that have mean and std in the names")

  i <- grep("mean", colnames(All_Combined_Data))

  j <- grep("std", colnames(All_Combined_Data))

  mean_std <- sort(c(i,j), decreasing=FALSE)

  Filtered_Data <- All_Combined_Data[,c(1,2,3,mean_std)]
  
**Adds Descriptive Names**

  print("Descriptive Names")

  names(Filtered_Data)<-gsub("^t", "Time", names(Filtered_Data))

  names(Filtered_Data)<-gsub("^f", "Frequency", names(Filtered_Data))

  names(Filtered_Data)<-gsub("Acc", "Accelerometer", names(Filtered_Data))

names(Filtered_Data)<-gsub("Gyro", "Gyroscope", names(Filtered_Data))

  names(Filtered_Data)<-gsub("Mag", "Magnitude", names(Filtered_Data))

  names(Filtered_Data)<-gsub("BodyBody", "Body", names(Filtered_Data))
  
**Generates a tidy data set with the average of each variable for each activity and each subject**

  print("Generate tidy data set with the average of each variable for each activity and each subject")

  Filtered_Data<-arrange(Filtered_Data,Subject,Activity)

  Final_Dataset<- aggregate(. ~ Subject - Activity, data = Filtered_Data, mean)
  
**Write it to a file named TidyDataAvg.txt**

  print("Write it to a file named TidyDataAvg.txt")

  write.table(Final_Dataset, "TidyDataAvg.txt", row.name=FALSE)

  print("Generation of TidyDataAvg.txt completed")


  [1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
  [2]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip