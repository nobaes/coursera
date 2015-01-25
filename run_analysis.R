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

