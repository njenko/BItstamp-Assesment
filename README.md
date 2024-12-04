# BItstamp Assesment

## Task 1
The first task is programmed in python. All the code and explanations are combined in the **Bitstamp_Assignment_Task1.ipynb** file.


## Task 2

This task is programmed in SQLite so that it can be run as a self-contained project. Where there exist better and more efficient solutions used in SQL (like median computation), they are added as a comment.

To run we first set the working directory to the folder with the data, in my case:

```bash
cd Data
```

Then create/open the database with:

```bash
sqlite3 bitstamp.db
```

And load the *.csv* files into the database

```bash
.mode csv
.import task2_userprofile.csv User_Profile
.import task2_trading_volume.csv Trading_Volume
.import task2_entities_mapping.csv Entities_Mapping
```

We then run all the queries in the **Task 2** folder. First we have:

```sql
 check_imported_data.sql 
```
This query checks the structure of all imported databases. We notice that some column names have issues. In table **User_Profile** the column name *'user_id '* has an extra space which we need to remove. Since SQLite does not support column renaming we have to create a new table with the same data (As far as my understanding, neither does MySQL, while in PostgreSQL there would be some additional issues with spaces in names. The solutions for both would be similar)
A similar issue apears in the table **Trading_Volume** where we have to fix the column name *'date '* to *date*.

----------------------

When the tables are properly loaded we prepare our supporting tables:
- **User_Countries**
    - *unique_id*
    - *current_country* (The latest country each user has set for themselves)
    - *original_country* (The original country each user has set, for the purpouses of entity assignment)

- **User_Countries_Entities**
    - *unique_id*
    - *current_country*
    - *original_country*
    - *correct_entity* (the entity that should be assigned to the user based ont thir current country)
    - *original_entity* (the entity that is assigned based on the original user country)

- **User_Volume_Stats**
    - *unique_id*
    - *total_volume*
    - *average_volume*
    - *median_volume*
    - *volume_above_average*

We do this by running:

```sql
 etl_queries.sql 
```

With all supporting tables prepared we can now solve the questions in part 3 with fairly simple queries:

- What was volume of NL clients on 2022-12-06?

```sql
 3a_query.sql 
```

The query gives us the answer: **34604**

- How many clients were on wrong entity on 2022-12-27?

```sql
 3b_query.sql 
```

The query gives us the answer: **2**

- Calculate volume per entity for Dec 2022.

```sql
 3c_query.sql 
```

The query gives us the answer:
| Entity | Total Volume |
| --- | --- |
| BVI | 259945 |
| INC | 668100 |
| PTE | 361551 |
| SA | 1888723 |


## Task 3