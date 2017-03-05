# This is a demonstration of cleaning data.
# It was developed for a Coursera course given by Jeff Leek.
#
# The data was collected for identifing human activity (running, walking, ..) 
# from smart phone sensors reading.
#
# The url for the original dataset and description is given below.
#
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

library(tidyr)
library(dplyr)

# We were given a zip file,
# I'll read the train file and the test file directly from the zip.
# I've placed the zip file in some subfolder under my home directory.

zip.file <-
        'C:\\Users\\Oren\\Coursera\\R - cleaning data\\getdata%2Fprojectfiles%2FUCI HAR Dataset.zip'

# reads a features file from the zip and returns a data frame
load.feature.file <- function(file.path.in.the.zip) {
        read.csv(unz(zip.file,file.path.in.the.zip),
                 header=F,
                 sep="",
                 na.string="",
                 colClasses = "numeric")
}

# reads a labels file from the zip and returns a data frame
load.label.file <- function(file.path.in.the.zip) {
        read.csv(unz(zip.file,file.path.in.the.zip),
                 header=F,
                 colClasses = 'factor')
}

# reads a subjects file from the zip and returns a data frame
load.subject.file <- function(file.path.in.the.zip) {
        read.csv(unz(zip.file,file.path.in.the.zip),
                 header=F,
                 colClasses = 'integer')
}


df.train <- load.feature.file("UCI HAR Dataset/train/X_train.txt")
df.train_label <- load.label.file("UCI HAR Dataset/train/y_train.txt")
df.train_subject <- load.label.file("UCI HAR Dataset/train/subject_train.txt")

df.test <- load.feature.file("UCI HAR Dataset/test/X_test.txt")
df.test_label <- load.label.file("UCI HAR Dataset/test/y_test.txt")
df.test_subject <- load.label.file("UCI HAR Dataset/test/subject_test.txt")

# still left todo:
#  merge into one df (or tbl_df),
#  give names,
#  extract relevant columns,

df.merged <- rbind(df.train,df.test) 

# this is also taken from the zip (the name of the features)
features <- read.csv(unz(zip.file,"UCI HAR Dataset/features.txt"),
                     header=F, sep="",
                     na.string="", colClasses = "character")

features <- paste0('var',features[,1],
                   '_',
                   tolower(gsub('[-(),]+','_',features[,2])))
#using '_' for clarity, can be changed in the future

names(df.merged) <- features

tbl_df <- tbl_df(df.merged) %>%
        select(grep('[mean|std]',features))

tbl_df$label <- rbind(df.train_label,df.test_label)[,1]

levels(tbl_df$label) <- c('WALKING',
                          'WALKING_UPSTAIRS',
                          'WALKING_DOWNSTAIRS',
                          'SITTING',
                          'STANDING',
                          'LAYING')

tbl_df$subject <- rbind(df.train_subject,df.test_subject)[,1]

# Now we're ready to create the summary as requested:
# i.e. the average of each variable for each activity and each subject

the_summary <- tbl_df %>%
        gather(var,val,-c(label,subject)) %>%
        group_by(var,label,subject) %>%
        summarise(avg=mean(val)) %>%
        ungroup()

# Code Book:

#> names(the_summary)
#[1] "var"     "label"   "subject" "avg"

# 'var' is the name of a column in the original dataset
# with some string manipulations.
# First part is a name of the form 'varInd_' which was added to avoid duplicates,
# this can also help in identifing the relevant field there.

# 'label' is the relevant activity (ex. WALKING etc).

# 'subject' is an ID of a subject (a human participant).

# 'avg' is the mean of the specific variable,
#   for the activity and the subject.

# Example use:

the_summary %>%
        filter(subject==15,var=='var10_tbodyacc_max_x') %>%
        select(label,avg)

## A tibble: 6 × 2
#label         avg
#<fctr>       <dbl>
#1            WALKING -0.09014102
#2   WALKING_UPSTAIRS  0.23609537
#3 WALKING_DOWNSTAIRS  0.61789936
#4            SITTING -0.93388870
#5           STANDING -0.92929508
#6             LAYING -0.91106129

