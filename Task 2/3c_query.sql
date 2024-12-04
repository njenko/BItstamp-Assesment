-- Since the entity is not changed automatically, we have to use original entity to calculate trading volume per entity
SELECT 
    uce.original_entity AS entity,
    SUM(tv.daily_trading_volume) AS total_volume
FROM Trading_Volume tv
JOIN User_Countries_Entities uce
    ON tv.unique_id = uce.unique_id
-- For current data this filter is unnecessary since we only have data for December 2022
WHERE tv.date BETWEEN '2022-12-01' AND '2022-12-31'
GROUP BY uce.original_entity;
