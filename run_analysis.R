

library(dplyr)
library(Hmisc)

# set up project root
folder = '/Users/JKG/Documents/00_coursera/gettingandcleaningdata/final project'
setwd(folder)

# set up main data folders
origDataFolder = "data/UCI HAR Dataset"
finalDataFolder = "data/final"
origDataFilePath = paste(folder, "/", origDataFolder, sep='')
finalDataFilePath = paste(folder, "/", finalDataFolder, sep='')

#files we'll need to create or extract
masterFileName = 'mergedMaster.txt'
masterFileWithPath = paste(finalDataFilePath, '/', masterFileName, sep='')

slimmerFileName = 'slimmer.txt'
slimmerFileWithPath = paste(finalDataFilePath, '/', slimmerFileName, sep='')

finalTidyFileName = 'finaltidy.txt'
finalTidyFileWithPath = paste(finalDataFilePath, '/', finalTidyFileName, sep='')


# pull original data files we'll need
# ACTIVITY LABELS, 6 x 2
activity_label_path = paste(origDataFolder,'/', 'activity_labels.txt', sep='')
activity_labels = read.table(activity_label_path)
colnames(activity_labels) <- c('id', 'activity.description')



# for processing all of the original data files from scratch into data frame 
# with labels, subjects, and observations from Test and Train sets   
mergeOriginalFiles = function () {
    
    
    # FEATURES, 561 x 2
    features_path = paste(origDataFolder,'/', 'features.txt', sep='')
    features = read.table(features_path)
    # transpose the features, from col to row, then append as top row on X documents once we have them
    features = t(features)
    featuresHeader = features[2,]
    
    ##
    ##
    ## TEST DATA
    ##
    ##
    
    #subject_test, 2947 x 1
    subject_test_path = paste(origDataFolder,'/', 'test/subject_test.txt', sep='')
    subject_test = read.table(subject_test_path)
    #add name/header
    colnames(subject_test) <- c('subject')
    
    #x_test, 2947 x 561
    x_test_path = paste(origDataFolder,'/', 'test/X_test.txt', sep='')
    x_test = read.table(x_test_path)
    # add name/header
    colnames(x_test) <- featuresHeader
    
    #y_test, 2947 x 1
    y_test_path = paste(origDataFolder,'/', 'test/Y_test.txt', sep='')
    y_test = read.table(y_test_path)
    # add name/header
    colnames(y_test) <- c('label')
    
    #merge these 3 test sets together, should be 2947 x 563
    allTest = cbind(subject_test, x_test, y_test)
    
    ##
    ##
    ## TRAIN DATA
    ##
    ##
    
    #subject_train, 7352 x 1
    subject_train_path = paste(origDataFolder,'/', 'train/subject_train.txt', sep='')
    subject_train = read.table(subject_train_path)
    #add name/header
    colnames(subject_train) <- c('subject')
    
    #x_train, 7352 x 561
    x_train_path = paste(origDataFolder,'/', 'train/X_train.txt', sep='')
    x_train = read.table(x_train_path)
    # add header
    colnames(x_train) <- featuresHeader
    
    #y_train, 7352 x 1
    y_train_path = paste(origDataFolder,'/', 'train/Y_train.txt', sep='')
    y_train = read.table(y_train_path)
    #add name/header
    colnames(y_train) <- c('label')
    
    #merge these 3 train sets together, should be 7352 x 563
    allTrain = cbind(subject_train, x_train, y_train)
    
    # combine allTest with allTrain to create the merged master, should be 10,299 (i.e. 7352 + 2947) x 563
    mergedMaster = rbind(allTest, allTrain)
    print(dim(mergedMaster))
    
    write.table(mergedMaster, masterFileWithPath)
    
    #now go create final output
    mergedMaster
} 

narrowOutput <- function (master) {
    print(dim(master))
    
    #get col with subjects
    subs = select(mergedMaster, contains('subject'))
    
    #get col with labels
    labels = select(mergedMaster, contains('label'))
    
    #get cols with "mean()"
    means = select(mergedMaster, contains('mean'))
    
    #get cols with "std()"
    stdevs = select(mergedMaster, contains('std'))
    
    #merge these 4
    slimmedDownMaster = cbind(subs, labels, means, stdevs)
    
    slimmedDownMaster
    
    # only use the data columns with mean() or std() in the name
    
}

appendActivityDesc <- function (data) {
    dataWithLabels = merge(data, activity_labels, by.x='label', by.y='id', all=TRUE)
    dataWithLabels
}

#
#
# PROCESSING STARTS HERE
# to save processing time, if main merge has already happened, no need to re-merge everything
# need a data frame called "slim" as output of this section
#
if(!file.exists(masterFileWithPath)) {
    mergedMaster = mergeOriginalFiles()
} else {
    if(!file.exists(slimmerFileWithPath)) {
        mergedMaster = read.table(masterFileWithPath)
        narrow = narrowOutput(mergedMaster)
        slim = appendActivityDesc(narrow)
        write.table(slim, slimmerFileWithPath)
    } else {
        slim = read.table(slimmerFileWithPath)
    }
}



# last step
#  from instructions: create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
grouped = group_by(slim, subject, activity.description)
# to get one summary variable
# summarise(grouped, tBodyAcc.mean...X = mean(tBodyAcc.mean...X, na.rm=TRUE) )
# get all variables (that aren't grouped) summarized (meaned)
output = summarise_each(grouped, funs(mean))
write.table(output, finalTidyFileWithPath, sep='\t')
