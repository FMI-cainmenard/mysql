
-- Use Insights database 
USE Insights;

-- Drop if exists to recreate
DROP TABLE IF EXISTS Company_Alias;

-- Create a new table to store the company aliases
CREATE TABLE Company_Alias (
    Data_Key__c VARCHAR(255) PRIMARY KEY,
    Alias VARCHAR(255) NOT NULL
);

-- Insert unique company IDs and their corresponding random aliases into the new table
INSERT INTO Company_Alias (Data_Key__c, Alias)
SELECT DISTINCT
    a.Data_Key__c,
    CONCAT(CHAR(FLOOR(RAND() * 26 + 65)), CHAR(FLOOR(RAND() * 26 + 97))) AS Alias
FROM
    SF_account a
RIGHT JOIN 
    SF_peer_groups b
    ON a.Peer_Group__c = b.Id
LEFT JOIN
    Company_Alias c
    ON a.Data_Key__c = c.Data_Key__c
WHERE c.Data_Key__c IS NULL
    AND a.Data_Key__c IS NOT NULL
GROUP BY
    a.Data_Key__c;
    