#Step 0 ####################
#####Download zip File######

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"data.zip")
unzip("data.zip")

# Step 1#####################
# Merge the training and test sets to create one data set ####
#####test set#########

setwd("C:/Users/usuario/Desktop/Getting_Data/UCI HAR Dataset/test")
X_test<-read.table("X_test.txt")
Y_test<-read.table("y_test.txt")
subject_test<-read.table("subject_test.txt")

###### train Set#######

setwd("C:/Users/usuario/Desktop/Getting_Data/UCI HAR Dataset/train")
X_train<-read.table("X_train.txt")
Y_train<-read.table("Y_train.txt")
subject_train<-read.table("subject_train.txt")

###### Total X & Y & Subject ##########

X_tot<-rbind(X_train,X_test)
Y_tot<-rbind(Y_train,Y_test)
subject_tot<-rbind(subject_train,subject_test)


### Step 2#############
# Extract only the measurements on the mean and standard deviation for each measurement####

setwd("C:/Users/usuario/Desktop/Getting_Data/UCI HAR Dataset")
features<-read.table("features.txt")
features_filter<-grep("-(mean|std)\\(\\)",features[,2])

# subset the desired columns

X_tot<-X_tot[,features_filter]
# correct the column names
names(X_tot) <- features[features_filter, 2]

# Use Descriptive Activities Names to name the activities #
### Step 3#############

setwd("C:/Users/usuario/Desktop/Getting_Data/UCI HAR Dataset")
activities<-read.table("activity_labels.txt")

#### convert in data frame and joining##########

library(plyr)
Y_totdf<-data.frame(Y_tot)
activities_df<-data.frame(activities)
ytot2<-join(Y_totdf,activities_df,by="V1")

#####ytot_def shows only the column with kind of activities####

ytot_def<-ytot2[,2]
ytot_def<-data.frame(ytot_def)

######Change Activities column##########

names(ytot_def)[1]<-paste("Activities")

#Step 4##########################################
# Appropriately label the data set with descriptive variable names########
###correct column name###
names(subject_tot)<-"subject"
all_data<-cbind(X_tot,ytot_def,subject_tot)

#Step5###########################################
# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject 
############################################################################### 
# 66 <- 68 columns but last two (activity & subject) 
averages_data <- ddply(all_data, .(subject, Activities), function(x) colMeans(x[, 1:66])) 
write.table(averages_data, "averages_data.txt", row.name=FALSE) 
