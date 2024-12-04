-- Query that returns trading volume for the Netherlands on 2022-12-06
SELECT 
    SUM(tv.daily_trading_volume) AS nl_volume
FROM Trading_Volume tv
JOIN Latest_Country lc 
    ON tv.unique_id = lc.unique_id
WHERE lc.country = 'NL' 
  AND tv.date = '2022-12-06';

