This repository is a submission of a Coursera assignment.

It is based on dataset from:

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script cleans and summerize the original files.

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


Disclaimer:

To use the scipt, you'll need to get a hold of a similar zip file, nd to change the path accordingly.
Alternatively, you can modify a little the script to refer to individual files.


