-- ================================================================================

-- Check constituon of User_Profile table
PRAGMA table_info(User_Profile);
SELECT * FROM User_Profile LIMIT 5;

-- Column name `unique_id ` has an extra space at the end -> correct it
CREATE TABLE User_Profile_Corrected AS
SELECT
    TRIM(`unique_id `) AS unique_id, -- Reference the exact column name with backticks
    country,
    date_changed
FROM User_Profile;

-- Check the corrected table 
PRAGMA table_info(User_Profile_Corrected);
SELECT * FROM User_Profile_Corrected LIMIT 5;

-- Rename the tables back to their original names
DROP TABLE IF EXISTS User_Profile;
ALTER TABLE User_Profile_Corrected RENAME TO User_Profile;

-- ================================================================================

-- Check constituon of Trading_Volume table
PRAGMA table_info(Trading_Volume);
SELECT * FROM Trading_Volume LIMIT 5;

-- Column name `date ` has an extra space at the end -> correct it
CREATE TABLE Trading_Volume_Corrected AS
SELECT
    unique_id,
    TRIM(`date `) AS date, -- Reference the exact column name with backticks
    daily_trading_volume
FROM Trading_Volume;

-- Check the corrected table
PRAGMA table_info(Trading_Volume_Corrected);
SELECT * FROM Trading_Volume_Corrected LIMIT 5;

-- Rename the tables back to their original names
DROP TABLE IF EXISTS Trading_Volume;
ALTER TABLE Trading_Volume_Corrected RENAME TO Trading_Volume;

-- ================================================================================

-- Check constituon of Entities_Mapping table
PRAGMA table_info(Entities_Mapping);
SELECT * FROM Entities_Mapping LIMIT 5;

