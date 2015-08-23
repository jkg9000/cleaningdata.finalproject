

### Introduction

This describes the variables, the data, and any transformations or work that I performed to clean up the data


#GOAL 1
Merge the test and training sets.

OVERALL:
features.txt -- a description of each of the 561 features, in order
activity_labels.txt -- each of the 6 labels for the observed/predicted activities


TEST: 
test/x_test.txt (2947 x 561) these are the test data sets, the input features from each subject across all 561 features
test/y_test.txt (2947 x 1)  (uses codes from activity_labels.txt), the predicted values
test/subject_test.txt (2947 x 1) subject (people) ID numbers for each observation

-- attach column headers, otherwise it'll get messy quickly!

TRAIN: 
train/x_train.txt (7352 x 561) these are the test data sets, the input features from each subject across all 561 features
train/y_train.txt (7352 x 1)  (uses codes from activity_labels.txt), the predicted values
train/subject_train.txt (7352 x 1) subject (people) ID numbers for each observation

I first extracted all of the files into data frames via read.table.

x_test and x_train data frames were given header names from the features.txt file;  
subject data frames were given the header "subject" 
y_test and y_train data frames were giving the header "label"

I used cbind to combine all the test sets and all the training sets, and then rbind to combine
the test and training set rows together

The final file / data frame for this is called "mergedMaster.txt"


#GOAL 2
2. Extract only the measurements on the mean and standard deviation for each measurement.

To narrow the output down, I used select statements from the dplyr package in order to get 
only those columns with "mean" or "std" in the column names:

means = select(mergedMaster, contains('mean'))

Using cbind, I combined the labels, subjects, mean and std columns into a new data frame / 
file, called "slimmer.txt"


#GOAL 3
3. Use descriptive activity names to name the activities in the data set
I created a method called appendActivityDesc that merged the slimmer.txt file (or data frame) 
with the activity_labels data frame.  This is also in the file slimmer.txt.


#GOAL 4
4. Appropriately label the data set with descriptive variable names.  
This was already done during the process for Goal #1.  I transposed the data frame from 
"features.txt" and used colnames() to append these feature labels to the header or mergedMaster.txt

#GOAL 5
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
I grouped the data frame "slim" (slimmer.txt) by subject and activity.description:

grouped = group_by(slim, subject, activity.description)

I then averaged all the other fields like so, and put it into a final data frame called "output":
output = summarise_each(grouped, funs(mean))

And then exported!  That's it.



