
/* How do I see the sysnonyms and base_object name of sysnonyms created in a database - TestOrders? */

SELECT 
    name, 
    base_object_name, 
    type
FROM 
    sys.synonyms
ORDER BY		-- If you have more than 1 synonyms
    name;		