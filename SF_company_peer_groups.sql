
-- Use Insights database
USE Insights;

-- Drop if exists
DROP TABLE IF EXISTS SF_company_peer_groups;

-- Create the SF_company_peer_groups table
CREATE TABLE IF NOT EXISTS SF_company_peer_groups (
  Company_Account_ID VARCHAR(255),
  PG_Company_Name VARCHAR(255),
  PG_Company_ID VARCHAR(255),
  Peer_Group_ID VARCHAR(255),
  Peer_Group_Name FLOAT,
  PRIMARY KEY (Company_Account_ID, Peer_Group_ID),
  FOREIGN KEY (Company_Account_ID) REFERENCES SF_account(Id),
  FOREIGN KEY (Peer_Group_ID) REFERENCES SF_peer_groups(Id)
);

-- Insert into table
INSERT INTO SF_company_peer_groups
SELECT 
    sf1.`Company Account ID`,
    sf1.`PG Company Name`,
    sf1.`PG Company ID`,
    sf1.`Peer Group ID`,
    sf1.`Peer Group Name`
FROM 
    (
        SELECT 
            `SF Account`.`Id` AS `Company Account ID`, 
            `SF Account`.`Name` AS `PG Company Name`, 
            `SF Account`.`Data_Key__c` AS `PG Company ID`, 
            `SF Peer Groups`.`Id` AS `Peer Group ID`, 
            `SF Peer Groups`.`Name` AS `Peer Group Name`
        FROM 
            `SF_account` AS `SF Account`
            LEFT JOIN `SF_peer_groups` AS `SF Peer Groups` 
                ON `SF Account`.`Peer_Group__c` = `SF Peer Groups`.`Id`
        WHERE 
            (`SF Peer Groups`.`Id` IS NOT NULL)
            AND ((`SF Peer Groups`.`Id` <> '') OR (`SF Peer Groups`.`Id` IS NULL))
    ) AS sf1
UNION ALL 
SELECT 
    sf2.`Company Account ID`,
    sf2.`PG Company Name`,
    sf2.`PG Company ID`,
    sf2.`Peer Group ID`,
    sf2.`Peer Group Name`
FROM 
    (
        SELECT 
            `SF Account`.`Id` AS `Company Account ID`, 
            `SF Account`.`Name` AS `PG Company Name`, 
            `SF Account`.`Data_Key__c` AS `PG Company ID`, 
            `SF Peer Groups 2`.`Id` AS `Peer Group ID`, 
            `SF Peer Groups 2`.`Name` AS `Peer Group Name`
        FROM 
            `SF_account` AS `SF Account`
            LEFT JOIN `SF_peer_groups` AS `SF Peer Groups 2` 
                ON `SF Account`.`X2nd_Peer_Group__c` = `SF Peer Groups 2`.`Id`
        WHERE 
            (`SF Peer Groups 2`.`Id` IS NOT NULL)
            AND ((`SF Peer Groups 2`.`Id` <> '') OR (`SF Peer Groups 2`.`Id` IS NULL))
    ) AS sf2
ORDER BY `PG Company Name`;


SELECT * FROM SF_company_peer_groups;
