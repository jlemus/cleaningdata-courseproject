#1 Prerequisites
#install the data.table package by running install.packages("data.table")
library(data.table) # load the data.table package by running library("data.table")
#install the data.table package by running install.packages("reshape2")
library(reshape2) # load the reshape2 package by running library(reshape2)

#1 Merges the training and the test sets to create one data set. 
wd <- getwd() #set your working directory to the location of the Samsung file

#Load each of the following files with the train and test data by using read.table and the corresponding path where the file is located
#Make sure to save each of the files into a variable with a meaningful name
# 1. X_test.txt
# 2. y_test.txt
# 3. X_train.txt
# 4. y_train.txt
# 5. subject_test.txt
# 6. subject_train.txt

fpath_X_test <- paste(wd, "/test/X_test.txt", sep = "")
X_test <- read.table(file = fpath_X_test)

fpath_y_test <- paste(wd, "/test/y_test.txt", sep = "")
y_test <- read.table(file = fpath_y_test)

fpath_X_train <- paste(wd, "/train/X_train.txt", sep = "")
X_train <- read.table(file = fpath_X_train)

fpath_y_train <- paste(wd, "/train/y_train.txt", sep = "")
y_train <- read.table(file = fpath_y_train)

fpath_subject_test <- paste(wd, "/test/subject_test.txt", sep = "")
subject_test <- read.table(file = fpath_subject_test)

fpath_subject_train <- paste(wd, "/train/subject_train.txt", sep = "")
subject_train <- read.table(file = fpath_subject_train)

# Use rbind() to merge the X test and X train data sets that you've previously saved
# These are the actual measurements for each of the variables considered
X_comb <- rbind(X_test, X_train)

# Use rbind() to merge the y test and y train data sets that you've previously saved
# These are the activities tied to the measurements in the X_train and X_test files
y_comb <- rbind(y_test, y_train)

# Use rbind() to merge the subject test and subject train data sets that you've previously saved
# These are the subjects tied to the measurements in the X_train and X_test files
subject_comb <- rbind(subject_test, subject_train)

# Use cbind() to merge subjects, the activities and the corresponding measurements into a single data frame.
# Use a variable with a meaningful and descriptive name.
merged_subXy <- cbind(subject_comb, y_comb, X_comb)

#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
# I interpeted that the mean values corresponding to the definition of
# mean() in the "features_info.txt" file are the only ones that must be extracted. 
# All of these mean values had a corresponding standard deviation. This interpretation
# is the reason why I have omitted mean frequency values in the resulting dataset.
# These are defined differently in the "features_info.txt" file.

#Load each of the file with all the features ("features.txt") by using read.table with the corresponding path where the file is located
#Make sure to save each of the files into a variable with a meaningful name
fpath_features <- paste(wd, "/features.txt", sep = "")
features <- read.table(file = fpath_features)

#Extract the indices for the wanted features/columns: the ones that are means of the other variables
#Use grep("mean()", fixed = T, features$V2) to obtain a vector with the indices
mean_features_ind <- grep("mean()", fixed = T, features$V2) 

#Extract the indices for the wanted features/columns: the ones that are standard deviations of the other variables
#Use grep("std()", fixed = T, features$V2) to obtain a vector with the indices
std_features_ind <- grep("std()", fixed = T, features$V2) 

#make a vector with the all the indices needed.
#indices for the wanted features/columns of both means and standard deviations
#Remember to sort the indices in ascending order if you wish to preserve the order of the columns from the 
#original dataset
mean_std_ind <- sort(c(mean_features_ind, std_features_ind)) 

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
merged_subXy_p3 <- merged_subXy_p2

#rename the first 2 columns of the data frame to something descriptive like "subject" and "activity"
colnames(merged_subXy_p3)[1:2]<-c("subject", "activity")

#Use the factor function on the activity column to label each value appropriately according to the "activity_labels.txt" file.
merged_subXy_p3$activity <- factor(merged_subXy_p3$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))


# fpath_activity_labels <- paste(wd, "/activity_labels.txt", sep = "")
# activity_labels <- read.table(file = fpath_activity_labels)
# 
# colnames(activity_labels)<-c("id", "activity")
# merged_subXy_p3 <- merge(activity_labels, merged_subXy_p2, by.x = "id", by.y = "activity")
# merged_subXy_p3[ ,1] <- merged_subXy_p3[ ,3]
# merged_subXy_p3 <- merged_subXy_p3[, -3]
# colnames(merged_subXy_p3)[1]<-"subject"

#4 Appropriately labels the data set with descriptive variable names.

# Make a copy of the data frame obtained in the previous step so you can make changes to the copy and avoid losing your work
merged_subXy_p4 <- merged_subXy_p3

# Save the names of the varables in the "features.txt" file in a variable. The make.names function makes syntactically valid names out of character vectors.
desc_variables <- make.names(as.character(features[,2][mean_std_ind]))

# Rename each of the 66 features with the meaningful names saved above.
colnames(merged_subXy_p4)[3:68] <- desc_variables

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Make a copy of the data frame obtained in the previous step so you can make changes to the copy and avoid losing your work
merged_subXy_p5 <- merged_subXy_p4

#Melt the data frame into a new data frame where the first two columns (subject and activity) are the only id variables
melted_p5 <- melt(merged_subXy_p5, id.vars = c("subject", "activity"))

#Use the dcast function on the melted data frame to create a new summarized data frame with the means of each variable
#by subject and activity
final_df_p5 <- dcast(melted_p5, subject + activity ~ variable, fun = mean)
