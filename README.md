# coursera
#for Getting and Cleaning Data: Course Project

This README.md have contents below:

- CodeBook.md includes all working process, data, variables in run_analysis.R for trasformation from raw data to tidy data.
- run_analysis.R includes R Code for trasformation from raw data to tidy data.
- tidy_data.txt is a tidy data seperated by space

##All PROCESS and <CodeBook.md.>#########################################
##the variables, the data, and any transformations or work

My data transformations with variables and datasets as following :

##First step, Making Test Dataset
1. subj_test: reading subject data in test group from ./test/subject_test.txt to be given from this project
2. X_test_1: reading X_test data in test group from ./test/X_test.txt to be given from this project
3. X_test_2: converting X_test data from " " to "_" for well splicing to appropriate 561 measurement variables
4. measurement_var_name: it is a variable list for 561 measurements. variables were given names that "measurement_no1,2,3,...,561".
5. X_test_3: splicing to appropriate 561 measurement variables using colsplit function, the variables's names were given from measurement_var_name.
6. X_test: it is same X_test_3, and X_test_1,2,3 deleted

7. Y_test: reading Y_test data in test group from ./test/Y_test.txt to be given from this project
8. giving variable name to Y_test as "Act_no", "Act_no" indicates "Activity number" - 1, 2, 3, 4, 5, 6

9. Test_set : making dataset for subjects in test group using cbind included subj_test, X_test, and Y_Test

##Second step, Making Training Dataset
9. subj_train: reading subject data in training group from ./train/subject_train.txt to be given from this project
10. X_train_1: reading X_train data in training group from ./train/X_train.txt to be given from this project
11. X_train_2: converting X_train data from " " to "_" for well splicing to appropriate 561 measurement variables
12. X_train_3: splicing to appropriate 561 measurement variables using colsplit function, the variables's names were given from measurement_var_name.
13. X_train: it is same X_train_3, and X_train_1,2,3 deleted

14. Y_train: reading Y_train data in training group from ./train/Y_train.txt to be given from this project
15. giving variable name to Y_train as "Act_no", "Act_no" indicates "Activity number" - 1, 2, 3, 4, 5, 6

16. Train_set: making dataset for subjects in training group using cbind included subj_train, X_train, and Y_train


##Third step, Merging Test & Train Dataset
17. Full_set: merging Test_set and Train_set by both subject and activity number

##Fourth step, Making format for tidy dataset & Calculating both Mean and SD
18. Full_set$stat_key: conbining subject and activity number for calculating mean and s.d. grouped by both subject and activity
19. Full_set_stat_list: extracting unique keys for stat_key and sorting by both subject and activity

20. k: number of stat_key, 180, it is also same to multipulating number of subjects:30 * number of activities:6

21. stat_set: making tidy data format using expand.grid function, it has both "SUBJ", "Act_no", "Measurement", "MEAN", and "SD" columns and 30*6*561 rows that calculated multipulating number of subjects, activities, and measurments.
21. MEAN, and SD columns have only NA and the column would get mean and sd values from next step.

22. Calculating mean and sd for all subjects using for function, both subjects and activities divided by stat_key as subseting
22. so, stat_set dataset would get mean and sd

##Fifth step, Labeling of activities
23. act_lab: reading labels of activity groups from ./activity_labels.txt to be given from this project.

24. tidy_data_tmp: merging stat_set and act_lab for the labeling.
25. solting tidy_data_tmp by 30 subjects, 6 activities, and 561 measurements

##Last step, Making tidy data
26. tidy_data: Making tidy data including "SUBJ", "ACTIVITY", "MEASUREMENT", "MEAN", and "SD" columns
27. Making new tidy data file using write.table function.


########################################################################
##<run_analysis.R>##########################################################
setwd("D:/R/P12_17/Course_Project")
getwd()

library(plyr)
library(reshape)
library(reshape2)
library(data.table)

######Making Test_Dataset ######################################
subj_test <- read.table("./test/subject_test.txt",sep=' ')
names(subj_test) <- c('SUBJ')

X_test_1 <- read.table("./test/X_test.txt",sep='\n',header=FALSE,stringsAsFactors=F) #탭으로 분할된 data 읽기. 
X_test_2 <- gsub(" ","_",X_test_1$V1)
X_test_2 <- gsub("__","_",X_test_2)

no<- seq(0,561,1)
measurement_var_name <- paste0("measurement_no",no)
X_test_3<-colsplit(X_test_2,"_",names=c(measurement_var_name))

X_test_3[,1] <- NULL
X_test <- X_test_3
X_test_3 <- NULL
X_test_2 <- NULL
X_test_1 <- NULL

Y_test <- read.table("./test/Y_test.txt",sep='\t')
names(Y_test) <- c("Act_no")
head(Y_test)

Test_set <- cbind(subj_test,Y_test,X_test)
head(Test_set)

######Making Training_Dataset ######################################
subj_train <- read.table("./train/subject_train.txt",sep=' ')
nrow(subj_train)
unique(subj_train)
names(subj_train) <- c('SUBJ')

X_train_1 <- read.table("./train/X_train.txt",sep='\n',header=FALSE,stringsAsFactors=F)

X_train_2 <- gsub(" ","_",X_train_1$V1)
X_train_2 <- gsub("__","_",X_train_2)

no<- seq(0,561,1)
measurement_var_name <- paste0("measurement_no",no)
X_train_3<-colsplit(X_train_2,"_",names=c(measurement_var_name))

X_train_3[,1] <- NULL
X_train<- X_train_3
X_train_3 <- NULL
X_train_2 <- NULL
X_train_1 <- NULL

Y_train<- read.table("./train/Y_train.txt",sep='\t')
names(Y_train) <- c("Act_no")

Train_set <- cbind(subj_train,Y_train,X_train)
#####Merge Test & Training Set##########################
Full_set <- rbind(Test_set,Train_set)

######Calculating Mean & SD for each of 561 measurements#############
Full_set$stat_key <- paste(Full_set$SUBJ,Full_set$Act_no,sep="_")
Full_set_stat_list <- unique(Full_set[,c("SUBJ","Act_no","stat_key")])
Full_set_stat_list <- Full_set_stat_list[order(Full_set_stat_list$SUBJ,Full_set_stat_list$Act_no),]
rownames(Full_set_stat_list) <- NULL
k<- nrow(Full_set_stat_list)

no<- seq(1,561,1)
measurement_var_name <- paste0("measurement_no",no)
stat_set <- expand.grid("SUBJ"=seq(1,30,1), "Act_no"=seq(1,6,1),"Measurement"=measurement_var_name)
stat_set <- stat_set[order(stat_set$Measurement,stat_set$SUBJ,stat_set$Act_no),]
stat_set$MEAN <- as.numeric(NA)
stat_set$SD <- as.numeric(NA)
rownames(stat_set) <- NULL

for(i in 1:561)
{
	for(j in 1:k)
	{
		stat_set_obs <- (i-1)*180+j
		stat_set_ij <- subset(Full_set[,c(1,2,2+i)],Full_set$stat_key==Full_set_stat_list[j,3])
		stat_set$MEAN[stat_set_obs] <- mean(stat_set_ij[,3],na.rm=T)
		stat_set$SD[stat_set_obs] <- sd(stat_set_ij[,3],na.rm=T)
	}
}
#head(stat_set)
#tail(stat_set)
rownames(stat_set) <- NULL

#####Input Acitivity Labels##############################
act_lab <- read.table("activity_labels.txt",sep=' ')
names(act_lab) <- c('Act_no', 'Activity')

tidy_data_tmp <- merge(stat_set,act_lab)
tidy_data_tmp <- tidy_data_tmp[order(tidy_data_tmp$SUBJ,tidy_data_tmp$Act_no,tidy_data_tmp$Measurement),]
rownames(tidy_data_tmp ) <- NULL
#####tidy data##################################
tidy_data <- data.frame(
SUBJ=tidy_data_tmp$SUBJ,
ACTIVITY=tidy_data_tmp$Activity,
MEASUREMENT=tidy_data_tmp$Measurement,
MEAN=tidy_data_tmp$MEAN,
SD=tidy_data_tmp$SD)

##Please upload your data set as a txt file created with write.table() using row.name=FALSE
write.table(tidy_data,"tidy_data.txt",row.name=FALSE)



