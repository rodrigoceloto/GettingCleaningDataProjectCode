## The working directory must be UCI HAR Dataset, with its subdirectories test and train, like created by unzipping the file getdata-projectfiles-UCI HAR Dataset.zip

Sys.setenv(LANG = "en")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

##Features
features<-read.table("features.txt")
colnames(features)<-c("colnumber","variablename")

##Test dataset binded with activity
test<-read.table("test/X_test.txt")

##Trainning dataset binded with activity
train<-read.table("train/X_train.txt")

##Merges the training and the test sets to create one data set
dataset<-rbind(test,train)

##Appropriately labels the data set with descriptive variable names
colnames(dataset)<-features$variablename

##Extracts only the measurements on the mean and standard deviation for each measurement
features$selection<-grepl("mean()",features$variablename,fixed=TRUE) | grepl("std()",features$variablename,fixed=TRUE) 
selectedcolumns<-as.vector(features[(features$selection==1),"variablename"])
dataset<-dataset[,selectedcolumns]

##Uses descriptive activity names to name the activities in the data set
  ##Add activity collumn
  testlabels<-read.table("test/y_test.txt")
  trainlabels<-read.table("train/y_train.txt")
  labels<-rbind(testlabels,trainlabels)
  dataset$activitycode<-as.factor(labels$V1)

  ##Add activity labels
  activity<-read.table("activity_labels.txt")
  colnames(activity)<-c("activitycode","activityname")
  dataset<-merge(dataset,activity,by.x="activitycode",by.y="activitycode",all=FALSE)

##Add subjects
testsubject<-read.table("test/subject_test.txt")
trainsubject<-read.table("train/subject_train.txt")
subject<-rbind(testsubject,trainsubject)
dataset$subject<-as.factor(subject$V1)



##Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
meltdataset<-melt(dataset,id=c("activitycode","activityname","subject"),measure.vars=selectedcolumns)
newdataset<-dcast(meltdataset,activitycode+activityname+subject ~ variable,mean)
write.table(newdataset,file="newdataset.txt",sep=",",row.names=FALSE)




      
