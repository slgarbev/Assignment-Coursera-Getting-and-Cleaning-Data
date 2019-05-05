The code in run_analysis.R does the following:

## Loading the dplyr package that is used in this analysis
library(dplyr) 

## Opening the data
fturs<-"./UCI HAR Dataset/features.txt"
actvty<-"./UCI HAR Dataset/activity_labels.txt"
filetest<-"./UCI HAR Dataset/test/X_test.txt"
namestest<-"./UCI HAR Dataset/test/y_test.txt"
subjecttest<-"./UCI HAR Dataset/test/subject_test.txt"
filetrain<-"./UCI HAR Dataset/train/X_train.txt"
namestrain<-"./UCI HAR Dataset/train/y_train.txt"
subjecttrain<-"./UCI HAR Dataset/train/subject_train.txt"

##Creating the tables
features<-read.table(fturs, col.names = c("n", "feature"))
activity<-read.table(actvty, col.names=c("act","activity"))
test<-read.table(filetest, col.names = features$feature)
testnames<-read.table(namestest, col.names = "act")
testsubject<-read.table(subjecttest, col.names = "subject")
train<-read.table(filetrain, col.names = features$feature)
trainnames<-read.table(namestrain, col.names = "act")
trainsubject<-read.table(subjecttrain, col.names = "subject")

##Step 1: Combining the subsets: Xdata contains the observations, Ydata contains the names of the activities, SUbjects contains the subjects in this data
Xdata<-rbind(train,test)
Ydata<-rbind(trainnames,testnames)
Subjects<-rbind(trainsubject,testsubject)

##Merging the entire data together: This creates a list where you see form left to right: The subject, The activities, and the observational variables
DataSet<-cbind(Subjects,Ydata,Xdata)

##Step 2: Tidying the dataset to contain only the means and standard deviations
cleandata<-select(DataSet,subject, act, contains("mean"), contains("std"))

##Step 3: Using descriptive names for the activities
cleandata$act<-activity[cleandata$act,"activity"]
names(cleandata)[2]<-"activity" ##Renaming the column to "activity"
names(cleandata)



##Step 4: Fixing the table names
names(cleandata)<-gsub("^t","Time", names(cleandata))
names(cleandata)<-gsub("^f","Frequency", names(cleandata))
names(cleandata)<-gsub("Acc","Accelerometer", names(cleandata))
names(cleandata)<-gsub("BodyBody","Body",names(cleandata))
names(cleandata)<-gsub("Gyro","Gyroscope",names(cleandata))
names(cleandata)<-gsub("Mag","Magnitude",names(cleandata))
names(cleandata)<-gsub("mean", "Mean" ,names(cleandata))
names(cleandata)<-gsub("std", "STD" ,names(cleandata))
names(cleandata)<-gsub("angle","Angle",names(cleandata))
names(cleandata)<-gsub("gravity","Gravity", names(cleandata))


##Step 5: Create an average for each subject and each activity for each variable
meanCleanData<-group_by(cleandata,subject,activity)
meanCleanData<-summarise_all(meanCleanData, funs(mean))

##Checking if the analysis was done correctly
str(meanCleanData)

##Extracting the data file
write.table(meanCleanData,"CleanDataMeans.txt",row.names = FALSE)
