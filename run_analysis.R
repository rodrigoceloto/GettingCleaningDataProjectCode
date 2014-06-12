## The working directory must be "UCI HAR Dataset" with its subdirectories test and train, like created by unzipping the file getdata-projectfiles-UCI HAR Dataset.zip

Sys.setenv(LANG = "en")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

##Features and units
features<-read.table("features.txt")
colnames(features)<-c("colnumber","variablename")

##Test dataset
test<-read.table("test/X_test.txt")

##Trainning dataset
train<-read.table("train/X_train.txt")

##Binds the training and the test sets to create one data set
dataset<-rbind(test,train)

##Labels the data set with descriptive variable names
colnames(dataset)<-features$variablename

##Extracts only the measurements on the mean and standard deviation for each measurement
features$selection<-grepl("mean()",features$variablename,fixed=TRUE) | grepl("std()",features$variablename,fixed=TRUE) 
selectedcolumns<-as.vector(features[(features$selection==1),"variablename"])
dataset<-dataset[,selectedcolumns]

##Write a file for codebook (only for documentation purposes)
features$units<-ifelse(grepl("Acc",features$variablename,fixed=TRUE)==1 | grepl("gravity",features$variablename,fixed=TRUE)==1,"g","radians/second")
CodeBookList<-features[(features$selection==1),c("variablename","units")]
vector<-paste("* ",CodeBookList$variablename," / ",CodeBookList$units)
write.table(vector,file="CodeBookList.txt",sep=",",row.names=FALSE,quote=FALSE)


##Add a column with descriptive activity names in the data set
  ##Add activity collumn to the dataset
  testlabels<-read.table("test/y_test.txt")
  trainlabels<-read.table("train/y_train.txt")
  labels<-rbind(testlabels,trainlabels)
  dataset$activitycode<-as.factor(labels$V1)

  ##Add activity labels (name)
  activity<-read.table("activity_labels.txt")
  colnames(activity)<-c("activitycode","activityname")
  dataset<-merge(dataset,activity,by.x="activitycode",by.y="activitycode",all=FALSE)

##Add subjects column to the dataset
testsubject<-read.table("test/subject_test.txt")
trainsubject<-read.table("train/subject_train.txt")
subject<-rbind(testsubject,trainsubject)
dataset$subject<-as.factor(subject$V1)

##Creates a  tidy dataset ("newdataset.txt") with the average of each variable b each activity and each subject
meltdataset<-melt(dataset,id=c("activitycode","activityname","subject"),measure.vars=selectedcolumns)
newdataset<-dcast(meltdataset,activitycode+activityname+subject ~ variable,mean)
write.table(newdataset,file="newdataset.txt",sep=",",row.names=FALSE)






      
