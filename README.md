# BItstamp Assesment

## Task 1
The first task is programmed in python. All the code and explanations are combined in the **Bitstamp_Assignment_Task1.ipynb** file.


## Task 2

This task is programmed in SQLite so that it can be run as a self contained project. Where there exist better and more efficient solutions used in SQL, they are added as a comment.



.mode csv
.import task2_userprofile.csv User_Profile
.import task2_trading_volume.csv Trading_Volume
.import task2_entities_mapping.csv Entities_Mapping

New table corrected from "user_id " to "user_id" made because you cant rename columns with SQLite

