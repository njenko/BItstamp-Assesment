CREATE VIEW Latest_Country AS
SELECT 
    unique_id, 
    country
FROM User_Profile
WHERE date_changed IS NULL;

PRAGMA table_info(Latest_Country);
SELECT * FROM Latest_Country LIMIT 5;

SELECT unique_id, country, date_changed FROM User_Profile LIMIT 5;