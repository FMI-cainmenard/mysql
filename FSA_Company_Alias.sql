USE Insights;

-- Drop if exists to recreate
DROP TABLE IF EXISTS FSA_Company_Alias;

-- Create a new table to store the company aliases
CREATE TABLE FSA_Company_Alias (
    Data_Key__c VARCHAR(255) PRIMARY KEY,
    Alias VARCHAR(255) NOT NULL
);

-- Insert unique company IDs and their corresponding random aliases into the new table
INSERT INTO FSA_Company_Alias (Data_Key__c, Alias)
SELECT DISTINCT
    a.Data_Key__c,
    CONCAT(CHAR(FLOOR(RAND() * 26) + 65),CHAR(FLOOR(RAND() * 26) + 97),CAST(FLOOR(RAND() * 10) AS CHAR(1))) AS Alias
FROM
    FSA_Main a
LEFT JOIN
    FSA_Company_Alias c
    ON a.Data_Key__c = c.Data_Key__c
WHERE c.Data_Key__c IS NULL
    AND a.Data_Key__c IS NOT NULL
GROUP BY
    a.Data_Key__c;

SELECT * FROM FSA_Company_Alias;