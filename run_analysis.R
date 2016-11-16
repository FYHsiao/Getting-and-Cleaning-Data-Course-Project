# 03 Gatting and Clearing Data Project
# Date: 2016/11/14
# Author: FY
#
# Project Instruction:
# The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was 
# selected for generating the training data and 30% the test data. 
#
# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#====================================================================
## 1: Merges the training and the test sets to create one data set.

library(dplyr)

test_sub_file = './UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt'   ## Test Subject 1~30
test_act_file = './UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt'         ## Test Activity 1~6
test_set_file = './UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt'         ## Test Feature 1~561
test_sub <- read.table(test_sub_file)
names(test_sub) <- c("Subject")
test_act <- read.table(test_act_file)
names(test_act) <- c("Activity")
test_set <- read.table(test_set_file)

train_sub_file = './UCI HAR Dataset/UCI HAR Dataset/test/subject_train.txt'  ## Train Subject 1~30
train_act_file = './UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt'       ## Train Activity 1~6
train_set_file = './UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt'       ## Train Feature 1~561
train_sub <- read.table(train_act_file)
names(train_sub) <- c("Subject")
train_act <- read.table(train_act_file)
names(train_act) <- c("Activity")
train_set <- read.table(train_set_file)

## merge test and train to new "data_set" 
data_sub <- bind_rows(test_sub, train_sub)
data_act <- bind_rows(test_act, train_act)
data_set <- bind_rows(test_set, train_set)

sub_act <- bind_cols(data_sub, data_act)
data <- bind_cols(data_set, sub_act)         ## A merged feature-subject-activity DF with test and train data

#====================================================================
## 2: Extracts only the measurements on the mean and standard deviation for each measurement.

feature_names_file = './UCI HAR Dataset/UCI HAR Dataset/features.txt'
feature_names <- read.table(feature_names_file)

#names(data) <- feature_names$V2
names(data) <- factor(append(as.character(feature_names$V2),"Subject"))
names(data) <- factor(append(as.character(names(data[1:562])),"Activity"))

## filter data_set for leaving only all mean() and std() measurements
sub_features_names <- feature_names$V2[grep("mean\\(\\)|std\\(\\)", feature_names$V2)]
data_2 <- subset(data, select = c(c(as.character(sub_features_names)), "Subject", "Activity"))

#====================================================================
## 3: Uses descriptive activity names to name the activities in the data set

# get activity_data data frame
activit_labels_file = './UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt'  ## activity_labels 1~6
activities_data <- read.table(activit_labels_file)
names(activities_data) <- c("Activity", "Activity_Desc")

# merge data_3 and activity_data by "Activity" column
data_3 <- merge(data_2, activities_data, by="Activity", all.x=TRUE)      # merge sort default is "TRUE"


#====================================================================
## 4: Appropriately labels the data set with descriptive variable names.

# features_info.txt
data_4 <- data_3
names(data_4)<-gsub("^t", "time", names(data_4))             # prefix 't' to denote time
names(data_4)<-gsub("^f", "frequency", names(data_4))        # 'f' to indicate frequency domain signals
names(data_4)<-gsub("Acc", "Accelerometer", names(data_4))
names(data_4)<-gsub("Gyro", "Gyroscope", names(data_4))
names(data_4)<-gsub("Mag", "Magnitude", names(data_4))
names(data_4)<-gsub("BodyBody", "Body", names(data_4))


#====================================================================
## 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table(data_4, "TidyData_5.txt", row.name=FALSE)
write.table(summary(data_4), "TidyData_5_Summary.txt", row.name=FALSE)
