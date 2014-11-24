cleaningdata-courseproject
Getting and Cleaning Data
by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD
==================================================================
Student: Juan M. Lemus
==================================================================

#1 Prerequisites
install the data.table package by running install.packages("data.table")
load the data.table package by running library("data.table")
install the data.table package by running install.packages("reshape2")
load the reshape2 package by running library(reshape2)

#1 Merge the training and the test sets to create one data set. 

- set your working directory to the location of the Samsung file

#Load each of the following files with the train and test data by using read.table and the corresponding path where the file is located
#Make sure to save each of the files into a variable with a meaningful name
# 1. X_test.txt
# 2. y_test.txt
# 3. X_train.txt
# 4. y_train.txt
# 5. subject_test.txt
# 6. subject_train.txt

# Use rbind() to merge the X test and X train data sets that you've previously saved
# These are the actual measurements for each of the variables considered

# Use rbind() to merge the y test and y train data sets that you've previously saved
# These are the activities tied to the measurements in the X_train and X_test files

# Use rbind() to merge the subject test and subject train data sets that you've previously saved
# These are the subjects tied to the measurements in the X_train and X_test files


# Use cbind() to merge subjects, the activities and the corresponding measurements into a single data frame.
# Use a variable with a meaningful and descriptive name.
merged_subXy <- cbind(subject_comb, y_comb, X_comb)

#2 Extracts only the measurements on the mean and standard deviation for each measurement. 

#Load each of the file with all the features ("features.txt") by using read.table with the corresponding path where the file is located
#Make sure to save each of the files into a variable with a meaningful name

#Extract the indices for the wanted features/columns: the ones that are means of the other variables
#Use grep("mean()", fixed = T, features$V2) to obtain a vector with the indices

#Extract the indices for the wanted features/columns: the ones that are standard deviations of the other variables
#Use grep("std()", fixed = T, features$V2) to obtain a vector with the indices

#make a vector with the all the indices needed.
#indices for the wanted features/columns of both means and standard deviations
#Remember to sort the indices in ascending order if you wish to preserve the order of the columns from the 
#original dataset

#Construct a new data frame that only includes the wanted features 
#To do this subset the current data frame by using the vector of indices obtained above
merged_subXy_p2 <- cbind(subject_comb, y_comb, X_comb[ , mean_std_ind])


#3 Uses descriptive activity names to name the activities in the data set

# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

# Make a copy of the data frame obtained in the previous step so you can make changes to the copy and avoid losing your work

#rename the first 2 columns of the data frame to something descriptive like "subject" and "activity"

#Use the factor function on the activity column to label each value appropriately according to the "activity_labels.txt" file.


#4 Appropriately labels the data set with descriptive variable names.

# Make a copy of the data frame obtained in the previous step so you can make changes to the copy and avoid losing your work

# Save the names of the varables in the "features.txt" file in a variable. The make.names function makes syntactically valid names out of character vectors.

# Rename each of the 66 features with the meaningful names saved above.

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Make a copy of the data frame obtained in the previous step so you can make changes to the copy and avoid losing your work


#Melt the data frame into a new data frame where the first two columns (subject and activity) are the only id variables


#Use the dcast function on the melted data frame to create a new summarized data frame with the means of each variable
#by subject and activity
