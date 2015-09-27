run_analysis <- function(){
  ## This script assumes the UCI HAR Dataset is unzipped in the working directory
  library(data.table)
  library(dplyr)
  working_directory <- getwd()
  
  ## Reading all the necessary data files
  print("Reading all the necessary data files")
  Features <- read.table(file.path(working_directory, "UCI HAR Dataset", "features.txt"))
  Activity_Labels <- read.table(file.path(working_directory, "UCI HAR Dataset", "activity_labels.txt"))
  
  Train_Subject <- read.table(file.path(working_directory, "UCI HAR Dataset", "train", "subject_train.txt"))
  Train_Activity_Num <- read.table(file.path(working_directory, "UCI HAR Dataset", "train", "y_train.txt"))
  Train_Data <- read.table(file.path(working_directory, "UCI HAR Dataset", "train", "X_train.txt"))
  
  Test_Subject <- read.table(file.path(working_directory, "UCI HAR Dataset", "test", "subject_test.txt"))
  Test_Activity_Num <- read.table(file.path(working_directory, "UCI HAR Dataset", "test", "y_test.txt"))
  Test_Data <- read.table(file.path(working_directory, "UCI HAR Dataset", "test", "X_test.txt"))
  
  ## Merging training and test data sets
  print("Merging training and test data sets")
  Combined_Subject <- rbind(Train_Subject, Test_Subject)
  Combined_Activity_Num <- rbind(Train_Activity_Num, Test_Activity_Num)
  Combined_Data <- rbind(Train_Data, Test_Data)
  All_Combined_Data <- cbind(Combined_Subject, Combined_Activity_Num, Combined_Data)
  
  ## Naming the coulmns according to features.txt
  print("Naming the coulmns according to features.txt")
  names(All_Combined_Data)[1]<-"Subject"
  names(All_Combined_Data)[2]<-"Activity_Num"
  setnames(All_Combined_Data, names(All_Combined_Data), c("Subject","Activity_Num",as.character(Features$V2)))
  
  ## Setting the Activity labels
  print("Setting the Activity labels")
  setnames(Activity_Labels, names(Activity_Labels), c("Activity_Num", "Activity"))
  All_Combined_Data <- merge(Activity_Labels, All_Combined_Data, by="Activity_Num", all.x=TRUE)
  
  ## Keeping only the column names that have mean and std in the names
  print("Keeping only the column names that have mean and std in the names")
  i <- grep("mean", colnames(All_Combined_Data))
  j <- grep("std", colnames(All_Combined_Data))
  mean_std <- sort(c(i,j), decreasing=FALSE)
  Filtered_Data <- All_Combined_Data[,c(1,2,3,mean_std)]
  
  ## Descriptive Names
  print("Descriptive Names")
  names(Filtered_Data)<-gsub("^t", "Time", names(Filtered_Data))
  names(Filtered_Data)<-gsub("^f", "Frequency", names(Filtered_Data))
  names(Filtered_Data)<-gsub("Acc", "Accelerometer", names(Filtered_Data))
  names(Filtered_Data)<-gsub("Gyro", "Gyroscope", names(Filtered_Data))
  names(Filtered_Data)<-gsub("Mag", "Magnitude", names(Filtered_Data))
  names(Filtered_Data)<-gsub("BodyBody", "Body", names(Filtered_Data))
  
  ## Generate tidy data set with the average of each variable for each activity and each subject
  print("Generate tidy data set with the average of each variable for each activity and each subject")
  Filtered_Data<-arrange(Filtered_Data,Subject,Activity)
  Final_Dataset<- aggregate(. ~ Subject - Activity, data = Filtered_Data, mean)
  
  ## Write it to a file named TidyDataAvg.txt
  print("Write it to a file named TidyDataAvg.txt")
  write.table(Final_Dataset, "TidyDataAvg.txt", row.name=FALSE)
  print("Generation of TidyDataAvg.txt completed")
}