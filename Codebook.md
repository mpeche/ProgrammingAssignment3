#Courcera: John Hobkin's Data Science Specialization
## Course 3: Getting and cleaning of data.
#### Codebook: Human Activity Recognition Using Smartphones Dataset

---

##Description
This dataset contains data that was collected for the purpose of recognising human activity, using the accelerometer and the gyroscope of a smartphone, the Samsung Galaxy S2 in particular. Thirty volunteers have participated in this study, performing six different activities as described below, whiles carrying a smartphone at the waist. 



##Data
The linear acceleration (recorded by the accelerometer), as well as the angular velocity (recorded by the gyroscope) of the volunteer was captured along the Cartesian coordinates (XYZ-Axis), each of which is displayed in a separate column. The data was recorded at a rate of 50Hz over 2.56 seconds to create a vector of 128 readings. The mean and standard deviation of these vectors was then calculated, and the average values for each volunteer's activity have been saved in the attached dataset.


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
###License:
No responsibility, implied or explicit, can be addressed to the authors or their institutions for use or misuse of this dataset. Any commercial use is prohibited.


###Reference
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


  