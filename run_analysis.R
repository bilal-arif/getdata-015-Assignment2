library(plyr)
setwd("D:/Uni Works/Data Science/Module 3/Assignment/UCI HAR Dataset/New folder")

dataSubjectTest<-read.table("subject_test.txt")
dataSubjectTrain<-read.table("subject_train.txt")

dataActivityTest<-read.table("y_test.txt")
dataActivityTrain<-read.table("y_train.txt")

dataTest<-read.table("X_test.txt")
dataTrain<-read.table("X_train.txt")

subject<-rbind(dataSubjectTest,dataSubjectTrain)
names(subject)<-"subject"
#setnames(subject,"V1","subject")

activity<-rbind(dataActivityTest,dataActivityTrain)
names(activity)<-"activityNum"
#setnames(subject,"V1","activityNum")

dataTable<-rbind(dataTest,dataTrain)

features<-read.table("features.txt")
names(features)<-c("featureNum","featureName")
colnames(dataTable)<-features$featureName

actlabels<-read.table("activity_labels.txt")
names(actlabels)<-c("activityNum","activityName")

subject<-cbind(subject,activity)

dataTable<-cbind(subject,dataTable)

featureMeanstd<-grep("mean|std",features$featureName,value=TRUE)
#featureMeanstd<-grep("mean\\(\\)|std\\(\\)",features$featureName,value=TRUE)

featureMeanstd<-union(c("subject","activityNum"),featureMeanstd)
dataTable<-dataTable[,featureMeanstd]

dataTable<-merge(actlabels,dataTable,by="activityNum",all.x=TRUE)
dataTable$activityName<-as.character(dataTable$activityName)

dataAgr<-aggregate(.~subject - activityName,data=dataTable,mean)
dataTable<-arrange(dataAgr,subject,activityName)

head(str(dataTable))

write.table(dataTable,"TidyData.txt",row.name=FALSE)
