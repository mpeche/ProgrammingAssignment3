setwd(file.path(getwd(),"Workspace","ProgrammingAssignment3"))
library(dplyr)

## *******************************************************************************************
## Step 1: Merge sets:
## ---------------------------
## Merge the training and test data sets to create one set.
## Since the data-set train and test are the same dimentions and type of data, a row-bind
##    will suffice. Add a counter to be used as a unique identifier (uid) afterwards.
## IMPORTANT: make sure the two sets are always bound in the SAME ORDER!!  train, then test!
##   
## Keep-in-mind: Use descriptive activity names.


combine_sets <- function(x,y,widths=c(1),fact=NULL){
  ##This function combines two dataset in the given text files into one dataset
  ##Input:	Two paths to the files, in order
  ##			Optional: Widths of the columns in the files
  ##			Optional: Factors to be applied to the new dataset
  ##Output:	A dataset where the data in the given files have been appended, one
  ##             after the other
  set_x <- read.fwf(file=x, widths=widths)
  set_y <- read.fwf(file=y, widths=widths)
  result <- rbind(set_x, set_y)
  if (is.null(fact)){
    ##just create a uid
    result <- result %>% 
      mutate(uid=c(1:nrow(result)))
  }else{
    ##If factors were supplied, create a uid and apply to dataset
    result <- result %>% 
      mutate(uid=c(1:nrow(result)),label=fact[result$V1]) %>%
      select(uid, label)
  }
  ##Clear memory
  rm(set_x)
  rm(set_y)
  result
}


##Training Labels as described in activity_labels.txt 
label_descriptions <- factor(c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                               "SITTING","STANDING","LAYING"))
train_file <- file.path(getwd(),"Dataset","train","y_train.txt")
test_file <- file.path(getwd(),"Dataset","test","y_test.txt")

labels <- combine_sets(train_file,test_file,fact=label_descriptions) %>%
  rename(activity=label)


##Test subjects, (represented as an integer 1-30, as per README.txt)
participants <- factor(1:30)
train_file <- file.path(getwd(),"Dataset","train","subject_train.txt")
test_file <- file.path(getwd(),"Dataset","test","subject_test.txt")

subjects <- combine_sets(train_file,test_file,fact=participants) %>%
  rename(volunteer=label)


##clear memory
rm(label_descriptions)
rm(participants)


## For the next files, every row shows a 128 element vector	
##Body Acceleration in the given direction(XYZ) 
##  Note this is the total minus gravity.
train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","body_acc_x_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","body_acc_x_test.txt")
body_acc_x <- combine_sets(train_file,test_file,widths=rep(16,128))

train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","body_acc_y_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","body_acc_y_test.txt")
body_acc_y <- combine_sets(train_file,test_file,widths=rep(16,128))

train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","body_acc_z_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","body_acc_z_test.txt")
body_acc_z <- combine_sets(train_file,test_file,widths=rep(16,128))



##Angular velocity
train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","body_gyro_x_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","body_gyro_x_test.txt")
body_gyro_x <- combine_sets(train_file,test_file,widths=rep(16,128))

train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","body_gyro_y_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","body_gyro_y_test.txt")
body_gyro_y <- combine_sets(train_file,test_file,widths=rep(16,128))

train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","body_gyro_z_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","body_gyro_z_test.txt")
body_gyro_z <- combine_sets(train_file,test_file,widths=rep(16,128))



##Total acceleration as recorded by Smartphone
train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","total_acc_x_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","total_acc_x_test.txt")
total_acc_x <- combine_sets(train_file,test_file,widths=rep(16,128))

train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","total_acc_y_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","total_acc_y_test.txt")
total_acc_y <- combine_sets(train_file,test_file,widths=rep(16,128))

train_file <- file.path(getwd(),"Dataset","train","Inertial Signals","total_acc_z_train.txt")
test_file <- file.path(getwd(),"Dataset","test","Inertial Signals","total_acc_z_test.txt")
total_acc_z <- combine_sets(train_file,test_file,widths=rep(16,128))




## *********************************************************************************************
## Step 2: Identify each individual volunteer-activity combination
## -----------------------------------------------------------------
## Since each 128-vector frame overlapse the previous frame by 50%, the duplicate data needs to
##   be removed. This can only be done if we can associate each vector with the correct subject-
##   activity pair.
## The last half of the last vector associated with each subject-activity pair is appended to the 
##   data set after the last half of each vector is removed.

resolve_overlap <- function(result){
  ##This function creates a duplicate of the last half of the last vector associated with a 
  ##   subject-activity pair, truncates the entire last half of the dataset, and re-adds the
  ##   saved half. This is done to remove the 50% overlap that exists
  ##Input:		The dataset that needs to be corrected.
  ##Output:		A fixed dataset
  ##Imporvement:	Currently the saved half still have the original column names (V65:V128)
  ##				   This needs to be renames to the columns of the first half (V1:V64)
  
  ##Identify the last vector associated with each subject-activity pair.
  index <- result %>% group_by(volunteer, activity) %>% summarise(lastVector=max(uid))
  ##Save the last half of the vectors identified in "index"
  hold <- result %>% select(-(V1:V64)) %>% filter(uid %in% index$lastVector)
  ##Truncate duplicate data and append data saved in "hold". Note uid is not unique anymore!!
  result <- result %>%
    select(-(V65:V128)) %>%
    bind_rows(hold)
  result <- mutate(result,uid=c(1:nrow(result)))
  
  rm(index)
  rm(hold)
  result	
}

Samsung_S2 <-  merge(subjects,labels,by.x="uid", by.y="uid")

body_acc_x <- Samsung_S2 %>% merge(body_acc_x,labels,by.x="uid", by.y="uid") %>% resolve_overlap()
body_acc_y <- Samsung_S2 %>% merge(body_acc_y,labels,by.x="uid", by.y="uid") %>% resolve_overlap()
body_acc_z <- Samsung_S2 %>% merge(body_acc_z,labels,by.x="uid", by.y="uid") %>% resolve_overlap()

body_gyro_x <- Samsung_S2 %>% merge(body_gyro_x,labels,by.x="uid", by.y="uid") %>% resolve_overlap()
body_gyro_y <- Samsung_S2 %>% merge(body_gyro_y,labels,by.x="uid", by.y="uid") %>% resolve_overlap()
body_gyro_z <- Samsung_S2 %>% merge(body_gyro_z,labels,by.x="uid", by.y="uid") %>% resolve_overlap()

total_acc_x <- Samsung_S2 %>% merge(total_acc_x,labels,by.x="uid", by.y="uid") %>% resolve_overlap()
total_acc_y <- Samsung_S2 %>% merge(total_acc_y,labels,by.x="uid", by.y="uid") %>% resolve_overlap()
total_acc_z <- Samsung_S2 %>% merge(total_acc_z,labels,by.x="uid", by.y="uid") %>% resolve_overlap()


## *********************************************************************************************
## Step 3: Calculations
## ---------------------------
## Extracts only the measurements on the mean and standard deviation for each measurement. 
##    Keep-in-mind: Appropriately label the data set with descriptive variable names. 

##Body Acceleration in the given direction(XYZ) 
body_acc_x$accX_mean = apply(select(body_acc_x,V1:V128),1,mean,na.rm=TRUE)
body_acc_x$accX_sd = apply(select(body_acc_x,V1:V128),1,sd,na.rm=TRUE)
body_acc_y$accY_mean = apply(select(body_acc_y,V1:V128),1,mean,na.rm=TRUE)
body_acc_y$accY_sd = apply(select(body_acc_y,V1:V128),1,sd,na.rm=TRUE)
body_acc_z$accZ_mean = apply(select(body_acc_z,V1:V128),1,mean,na.rm=TRUE)
body_acc_z$accZ_sd = apply(select(body_acc_z,V1:V128),1,sd,na.rm=TRUE)


##Angular velocity
body_gyro_x$gyroX_mean = apply(select(body_gyro_x,V1:V128),1,mean,na.rm=TRUE)
body_gyro_x$gyroX_sd = apply(select(body_gyro_x,V1:V128),1,sd,na.rm=TRUE)
body_gyro_y$gyroY_mean = apply(select(body_gyro_y,V1:V128),1,mean,na.rm=TRUE)
body_gyro_y$gyroY_sd = apply(select(body_gyro_y,V1:V128),1,sd,na.rm=TRUE)
body_gyro_z$gyroZ_mean = apply(select(body_gyro_z,V1:V128),1,mean,na.rm=TRUE)
body_gyro_z$gyroZ_sd = apply(select(body_gyro_z,V1:V128),1,sd,na.rm=TRUE)


##Body Acceleration in the given direction(XYZ) 
total_acc_x$totalX_mean = apply(select(total_acc_x,V1:V128),1,mean,na.rm=TRUE)
total_acc_x$totalX_sd = apply(select(total_acc_x,V1:V128),1,sd,na.rm=TRUE)
total_acc_y$totalY_mean = apply(select(total_acc_y,V1:V128),1,mean,na.rm=TRUE)
total_acc_y$totalY_sd = apply(select(total_acc_y,V1:V128),1,sd,na.rm=TRUE)
total_acc_z$totalZ_mean = apply(select(total_acc_z,V1:V128),1,mean,na.rm=TRUE)
total_acc_z$totalZ_sd = apply(select(total_acc_z,V1:V128),1,sd,na.rm=TRUE)




## *********************************************************************************************
## Step 5: Tidy data set
## ---------------------------
## Combine all measurements into one independant TIDY dataset
## Remember, a tidy dataset is:
##    1 Each variable forms a column
##    2 Each observation forms a row
##    3 Each type of observational unit forms a table


## Adds the variables one after the other to the new data.frame,
Samsung_S2 <-  select(body_acc_x,volunteer,activity,uid,accX_mean:accX_sd) %>%
  ##Merge Body Acceleration
  merge(select(body_acc_y,uid,accY_mean:accY_sd),by.x="uid", by.y="uid") %>%
  merge(select(body_acc_z,uid,accZ_mean:accZ_sd),by.x="uid", by.y="uid") %>%
  ##Merge Angular Acceleration
  merge(select(body_gyro_x,uid,gyroX_mean:gyroX_sd),by.x="uid", by.y="uid") %>%
  merge(select(body_gyro_y,uid,gyroY_mean:gyroY_sd),by.x="uid", by.y="uid") %>%
  merge(select(body_gyro_z,uid,gyroZ_mean:gyroZ_sd),by.x="uid", by.y="uid") %>%
  ##Merge Total Recorded Acceleration
  merge(select(total_acc_x,uid,totalX_mean:totalX_sd),by.x="uid", by.y="uid") %>%
  merge(select(total_acc_y,uid,totalY_mean:totalY_sd),by.x="uid", by.y="uid") %>%
  merge(select(total_acc_z,uid,totalZ_mean:totalZ_sd),by.x="uid", by.y="uid")

##Group all observations acording to volunteer and activity, and 
##  calculate the mean for each of the variables
Samsung_S2 <- Samsung_S2 %>% group_by(volunteer, activity) %>%
  mutate(
    #Averages of Body Acceleration
    accX_mean = mean(accX_mean), accX_sd = mean(accX_sd),
    accY_mean = mean(accY_mean), accY_sd = mean(accY_sd),
    accZ_mean = mean(accZ_mean), accZ_sd = mean(accZ_sd),
    ##Averages of Angular Acceleration
    gyroX_mean = mean(gyroX_mean), gyroX_sd = mean(gyroX_sd),
    gyroY_mean = mean(gyroY_mean), gyroY_sd = mean(gyroY_sd),
    gyroZ_mean = mean(gyroZ_mean), gyroZ_sd = mean(gyroZ_sd),
    ##Averages of Total Recorded Acceleration
    totalX_mean = mean(totalX_mean), totalX_sd = mean(totalX_sd),
    totalY_mean = mean(totalY_mean), totalY_sd = mean(totalY_sd),
    totalZ_mean = mean(totalZ_mean), totalZ_sd = mean(totalZ_sd)) %>%
  ## Collapse to display unique records   
  select(-uid) %>% unique()

## *********************************************************************************************
## Write away for later use
## ------------------------
Samsung_S2 <- Samsung_S2[order(Samsung_S2$volunteer, Samsung_S2$activity),]
write.table(Samsung_S2,"Assignment_3.txt",row.names = FALSE)
