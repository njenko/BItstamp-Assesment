-- Create a view to get the latest country for each user
CREATE VIEW Latest_Country AS
SELECT 
    unique_id, 
    country
FROM User_Profile
WHERE date_changed IS '';

-- Create a view to add entity to each user
CREATE VIEW User_Entity AS
SELECT
    lc.unique_id,
    lc.country,
    em.entity
FROM Latest_Country lc
LEFT JOIN Entities_Mapping em
ON lc.country = em.country;

-- We don't need to create this table if it is only a one time query
CREATE TABLE User_Volume_Stats (
    unique_id TEXT PRIMARY KEY,
    total_volume REAL,
    average_volume REAL,
    median_volume REAL,
    volume_above_average TEXT -- BOOLEAN if I was using PostgreSQL or MySQL
);

-- The query below can be used as a one time query or to insert data into the table

-- Calculate the average trading volume for the exchange
WITH ExchangeAverage AS (
    SELECT AVG(CAST(daily_trading_volume AS REAL)) AS exchange_average
    FROM Trading_Volume
),
-- Calculate the total and average trading volume for each user
UserVolumes AS (
    SELECT 
        unique_id,
        SUM(CAST(daily_trading_volume AS REAL)) AS total_volume,
        AVG(CAST(daily_trading_volume AS REAL)) AS average_volume
        -- Our code calculates the average volume for each user only for the days when they are trading.
        -- If we want to calculate the average volume for all days we would have to devide the total volume by the number of days:
        -- SUM(CAST(daily_trading_volume AS REAL)) / COUNT(DISTINCT date) AS average_volume_all_days
    FROM Trading_Volume
    GROUP BY unique_id
),
-- Rank the trading volumes for each user and calculate the median
-- If we were using PostgreSQL or MySQL we could use 
-- PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(daily_trading_volume AS REAL)) to calculate the median
RankedVolumes AS (
    SELECT
        unique_id,
        daily_trading_volume,
        ROW_NUMBER() OVER (PARTITION BY unique_id ORDER BY CAST(daily_trading_volume AS REAL)) AS row_num,
        COUNT(*) OVER (PARTITION BY unique_id) AS total_rows
    FROM Trading_Volume
),
UserMedian AS (
    SELECT
        unique_id,
        AVG(CAST(daily_trading_volume AS REAL)) AS median_volume
    FROM RankedVolumes
    WHERE row_num IN (total_rows / 2, total_rows / 2 + 1)
    GROUP BY unique_id
)
-- Use the calculated values to insert data into the User_Volume_Stats table
-- Comment out if you are using this query as a one time query
INSERT INTO User_Volume_Stats

-- Select the data that is desired as part of task 2.2
SELECT 
    uv.unique_id,
    uv.total_volume,
    uv.average_volume,
    um.median_volume,
    CASE 
        -- In SQLite we do not have boolean data type so we use 'true' and 'false' as strings
        WHEN uv.total_volume > ea.exchange_average THEN 'True'
        ELSE 'False'
    END AS volume_above_average
FROM UserVolumes uv
JOIN UserMedian um ON uv.unique_id = um.unique_id
CROSS JOIN ExchangeAverage ea;



