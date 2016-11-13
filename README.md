#Courcera: John Hobkin's Data Science Specialization
## Course 3: Getting and cleaning of data.
#### Human Activity Recognition Using Smartphones Dataset
---
##Description
This dataset contains data that was collected for the purpose of recognising human activity, using the accelerometer and the gyroscope of a smartphone, the Samsung Galaxy S2 in particular. Thirty volunteers have participated in this study, performing six different activities as described below, whiles carrying a smartphone at the waist. 



##Data
The linear acceleration (recorded by the accelerometer), as well as the angular velocity (recorded by the gyroscope) of the volunteer was captured in three dimensions, along the Cartesian coordinates (XYZ-Axis).  The data was recorded at a rate of 50Hz, and after passing through a noise filter was then divided into segments of 2.56 seconds to create a vector of 128 readings. These vectors overlap each other at about 50%.
The movements from the body alone was calculated by removing the Earth's gravitational influence from the data obtained by the accelerometer. This was done by passing the recorded signals through a Butterworth low-pass filter.   

####Columns
  * __total__		The signal recorded by the accelerometer, along each of the Cartesian Axis. These values are measured in gravitational-units, or 9.8 meters/second-squared, and represented as a vector with 128 values.
  
  * __acc__			The body's acceleration. These values are measured in gravitational-units, and represented as a vector with 128 values.
  
  * __gyro__		The signal recorded by the gyroscope, along each of the Cartesian Axis. These values are measured in radiant/second, and represented as a vector with 128 values.

####Activities
The activities that the volunteers performed while being recorded was:
  * WALKING
  * WALKING_UPSTAIRS
  * WALKING_DOWNSTAIRS
  * SITTING
  * STANDING
  * LAYING

--- 
##Files in this repository

This repository contians the following files:
  * README.md			This file, which gives an overview of the data, the files in the repository, the process by which the data was processed, and finally legal details.
  * Codebook.md			The codebook contains an overview of the data after it had been processed.
  * run_analysis.r		R script that contains the code by which the original data have been processed.
  * Assignment_3.txt	The tidy data set after processing.
  
--- 
##Processing the Data
The original data have been obtained from the following link [UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). This specific data-set is Version 1.0, as distributed by Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.[1]
The accompanying R-script _run_analysis.r_ contains the code used to process the data.

####Initial Analysis
The data in the original set is spread out across several files. Each of the recording made by the smartphone, along each of the Cartesian Axis, have been stored in a different file. Therefore there were nine files for the smartphone data itself. Furthermore, the subject and label identities were also stored in separate files. Then finally, data for 30% of the subjects have been separated from the dataset to divide it into a train and test set. 

####Step 1: Merging the Train & test sets
Since the goal of this course is not to develop a machine learning algorithm, the data doesn't need to be separated into distinct training and testing sets. These sets have been combined into a single set once more, by simply appending the test rows __behind__ the corresponding train data. Since there is no unique identifier across any of data files, a row counter was added to each newly created set to function as a unique identifier (_uid_).

In addition to the above steps, the _mean_ and _standard deviation_ of each vector in the data recorded by the smartphone was also calculated and added to the appropriate dataset. Also, since the frames overlap each other at 50%, the second half of each vector have been truncated, except the last vector for the associated volunteer-activity pair.

####Step 2: Combining the different data files
Using the newly created _uid_, each experimental instance was matched. The original data files were merged in the following order:
  * Volunteers
  * Activity-label
  * Body Acceleration
  * Angular Acceleration
  * Total Recorded Acceleration

####Step 3: Calculations.
The final step of the processing involved compressing the entire data-set to include only one set of variables for each volunteer-activity pair. This was done by grouping the data according to volunteer-id and activity-description, then calculation the mean of each variable for each group.


####Omissions
The original dataset also contained vectors that contained time and frequency variables. However, since this dataset doesn't store the changes in movement over time, this information have been left out.

---
###License:
No responsibility, implied or explicit, can be addressed to the authors or their institutions for use or misuse of this dataset. Any commercial use is prohibited.


###Reference
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

