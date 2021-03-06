library(dplyr)

fturs<-"./UCI HAR Dataset/features.txt"
actvty<-"./UCI HAR Dataset/activity_labels.txt"
filetest<-"./UCI HAR Dataset/test/X_test.txt"
namestest<-"./UCI HAR Dataset/test/y_test.txt"
subjecttest<-"./UCI HAR Dataset/test/subject_test.txt"
filetrain<-"./UCI HAR Dataset/train/X_train.txt"
namestrain<-"./UCI HAR Dataset/train/y_train.txt"
subjecttrain<-"./UCI HAR Dataset/train/subject_train.txt"

features<-read.table(fturs, col.names = c("n", "feature"))
activity<-read.table(actvty, col.names=c("act","activity"))
test<-read.table(filetest, col.names = features$feature)
testnames<-read.table(namestest, col.names = "act")
testsubject<-read.table(subjecttest, col.names = "subject")
train<-read.table(filetrain, col.names = features$feature)
trainnames<-read.table(namestrain, col.names = "act")
trainsubject<-read.table(subjecttrain, col.names = "subject")

Xdata<-rbind(train,test)
Ydata<-rbind(trainnames,testnames)
Subjects<-rbind(trainsubject,testsubject)

DataSet<-cbind(Subjects,Ydata,Xdata)

cleandata<-select(DataSet,subject, act, contains("mean"), contains("std"))

cleandata$act<-activity[cleandata$act,"activity"]
names(cleandata)[2]<-"activity" ##Renaming the column to "activity"
names(cleandata)



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


meanCleanData<-group_by(cleandata,subject,activity)
meanCleanData<-summarise_all(meanCleanData, funs(mean))

str(meanCleanData)

write.table(meanCleanData,"CleanDataMeans.txt",row.names = FALSE)
