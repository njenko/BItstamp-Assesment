-- Query returning the number of clients that have the wrong entity assigned
SELECT 
    COUNT(*) AS clients_on_wrong_entity
FROM User_Countries_Entities
WHERE correct_entity != original_entity;
