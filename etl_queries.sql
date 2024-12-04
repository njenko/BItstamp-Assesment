CREATE TABLE UserProfiles_Clean AS
SELECT
    unique_id,
    country,
    MAX(date_changed) AS last_date_changed
FROM User_Profile
WHERE date_changed IS NULL
GROUP BY unique_id, country;

CREATE TABLE TradingVolume_Clean AS
SELECT
    unique_id,
    trading_date,
    SUM(volume) AS daily_volume
FROM Trading_Volume
GROUP BY unique_id, trading_date;

