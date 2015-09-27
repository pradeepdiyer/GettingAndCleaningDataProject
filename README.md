**About the run_analysis function**

<p>The purpose of the run_analysis function in the run_function.R file is to generate an independent tidy data set with the average of each variable for each activity and each subject.</p>

The data.table and dplyr packages need to be installed in R for the run_analysis() function to work.

The run_analysis function assumes you have the UCI HAR Data set downloaded and unzipped in the working directory.

<p>The run_analysis function does not take any parameters and can be run simply by sourcing the run_function.R file and executing the run_analysis() function.</p>

The description of how the script works is in the CodeBook.md file.

The output will be a .txt file that is stored in the working directory and called *TidyDataAvg.txt*

**To view the tidy data set, try the following commands in R:**

library(data.table)

TidyDataAvg <- read.table(file.path(getwd(), "TidyDataAvg.txt"))

View(TidyDataAvg)