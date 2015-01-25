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







