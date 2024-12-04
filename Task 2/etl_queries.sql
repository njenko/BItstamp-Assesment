-- Create a view to get the latest country and the original country for each user
DROP VIEW IF EXISTS User_Countries;

CREATE VIEW User_Countries AS
WITH Ranked_Profile AS (
    SELECT 
        unique_id,
        country,
        date_changed,
        -- Rank rows for original_country based on the earliest `date_changed`
        ROW_NUMBER() OVER (
            PARTITION BY unique_id
            ORDER BY 
                CASE WHEN date_changed IS NOT '' THEN date_changed END ASC NULLS LAST
        ) AS rank_original,
        -- Identify the row for current_country where `date_changed IS ''`
        ROW_NUMBER() OVER (
            PARTITION BY unique_id
            ORDER BY 
                CASE WHEN date_changed IS '' THEN 1 ELSE 2 END
        ) AS rank_current
    FROM User_Profile
)
SELECT 
    unique_id,
    -- Current country: Row with rank_current = 1
    MAX(CASE WHEN rank_current = 1 THEN country END) AS current_country,
    -- Original country: Row with rank_original = 1
    MAX(CASE WHEN rank_original = 1 THEN country END) AS original_country
FROM Ranked_Profile
GROUP BY unique_id;



-- ====================================================================================================
-- Create a view to add current entity and the correct to each user
CREATE VIEW User_Countries_Entities AS
SELECT 
    uc.unique_id,
    uc.current_country,
    uc.original_country,
    -- Get the entity for the current country
    em1.entity AS correct_entity,
    -- Get the entity for the original country
    em2.entity AS original_entity
FROM User_Countries uc
LEFT JOIN Entities_Mapping em1
    ON uc.current_country = em1.country
LEFT JOIN Entities_Mapping em2
    ON uc.original_country = em2.country;


-- ====================================================================================================
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



