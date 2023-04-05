
-- Use Insights database
USE Insights;

-- Create View
CREATE OR REPLACE VIEW Insights.FSA_View AS 
SELECT 

/* Demographics */
	-- Company ID
    a.`Name` AS `Company Name`,
    -- Company Alias
    e.Alias AS `Company Alias`,
    -- Salesforce ID
    a.`Salesforce ID` AS `Salesforce ID`,
	-- Year
	a.`Year`,
    -- NAICS Code
    CASE 
		WHEN COALESCE(REPLACE(c.`NAICS`,"P",""),IFNULL(a.`NaicsCode`,'NULL')) = '335999'
			THEN '444100'
		WHEN COALESCE(REPLACE(c.`NAICS`,"P",""),IFNULL(a.`NaicsCode`,'NULL')) = '423320'
			THEN '444100'
		WHEN COALESCE(REPLACE(c.`NAICS`,"P",""),IFNULL(a.`NaicsCode`,'NULL')) = '531210'
			THEN '236220'
		WHEN COALESCE(REPLACE(c.`NAICS`,"P",""),IFNULL(a.`NaicsCode`,'NULL')) = '484110' 
			AND (COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Highway, Street, and Bridge Construction' OR 'Highway, Street & Bridge Construction')
			THEN '237310'
		WHEN COALESCE(REPLACE(c.`NAICS`,"P",""),IFNULL(a.`NaicsCode`,'NULL')) = '336992'
			THEN '236210'
		ELSE COALESCE(REPLACE(c.`NAICS`,"P",""),IFNULL(a.`NaicsCode`,'NULL'))
		END AS `NAICS Code`,
    -- RMA NAICS Industry
    CASE 
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Highway, Street, and Bridge Construction'
			THEN 'Highway, Street & Bridge Construction'
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Industrial Building'
			THEN 'Industrial Building Construction'
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'All Other Miscellaneous Electrical Equipment and Component Manufacturing'
			THEN 'Building Material and Supplies Dealers'
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Brick, Stone, and Related Construction Material Merchant Wholesalers'
			THEN 'Building Material and Supplies Dealers'
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Commercial and Institutional Building Construction'
			THEN 'Commercial & Institutional Building Construction'
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Plumbing, Heating, and Air-Conditioning Contractors'
			THEN 'Plumbing, Heating, & Air-Conditioning'
		WHEN COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL')) = 'Water and Sewer Line and Related Structures Construction'
			THEN 'Water and Sewer Line & Related Structures Construction'
		ELSE COALESCE(c.`Industry`,IFNULL(a.`NaicsDesc`,'NULL'))
		END AS `NAICS Industry`,
    -- Primary Sector
    a.`Primary_Sector__c` AS `Primary Sector`,

/* Balance Sheet - Assets */

/* Cash & Cash Equivalents */ 
    CAST(IFNULL(b.`Cash & Cash Equivalents`,0)+IFNULL(b.`Marketable Securities`,0) AS DECIMAL(15,2)) AS `Cash & Cash Equivalents`,
		-- CS Cash & Cash Equivalents
		CAST((IFNULL(b.`Cash & Cash Equivalents`,0)+IFNULL(b.`Marketable Securities`,0))/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Cash & Cash Equivalents`,

/* Marketable Securities */ 
    CAST(IFNULL(b.`Marketable Securities`,0) AS DECIMAL(15,2)) AS `Marketable Securities`,
		-- CS Marketable Securities 
		CAST((IFNULL(b.`Marketable Securities`,0))/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Marketable Securities`,

/* Total Liquid Assets */ 
    CAST(IFNULL(b.`Marketable Securities`,0)+IFNULL(b.`Cash & Cash Equivalents`,0) AS DECIMAL(15,2)) AS `Total Liquid Assets`,
		-- CS Total Liquid Assets
		CAST((IFNULL(b.`Marketable Securities`,0)+IFNULL(b.`Cash & Cash Equivalents`,0))/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Liquid Assets`,

/* Accounts Receivable - Trade */ 
    CAST(IFNULL(b.`Accounts Receivable - Trade`,0) AS DECIMAL(15,2)) AS `Accounts Receivable - Trade`,
		-- CS Accounts Receivable - Trade
		CAST(IFNULL(b.`Accounts Receivable - Trade`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accounts Receivable - Trade`,

/* Accounts Receivable - Other */ 
    CAST(IFNULL(b.`Accounts Receivable - Other`,0) AS DECIMAL(15,2)) AS `Accounts Receivable - Other`,
		-- CS Accounts Receivable - Other
		CAST(IFNULL(b.`Accounts Receivable - Other`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accounts Receivable - Other`,

/* Accounts Receivable - Current Retention */ 
    CAST(IFNULL(b.`Accounts Receivable - Current Retention`,0) AS DECIMAL(15,2)) AS `Accounts Receivable - Current Retention`,
		-- CS Accounts Receivable - Current Retention
		CAST(IFNULL(b.`Accounts Receivable - Current Retention`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accounts Receivable - Current Retention`,

/* Total Accounts Receivable */ 
    CAST(IFNULL(b.`Total Accounts Receivable`,0) AS DECIMAL(15,2)) AS `Total Accounts Receivable`,
		-- CS Total Accounts Receivable
		CAST(IFNULL(b.`Total Accounts Receivable`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Accounts Receivable`,

/* Inventory */ 
    CAST(IFNULL(b.`Inventory`,0) AS DECIMAL(15,2)) AS `Inventory`,
		-- CS Inventory 
        CAST(IFNULL(b.`Inventory`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Inventory`,

/* Cost & Estimated Earnings in Excess of Billings */ 
	CAST(IFNULL(b.`Cost & Estimated Earnings in Excess of Billings`,0) AS DECIMAL(15,2)) AS `Cost & Estimated Earnings in Excess of Billings`,
		-- CS Cost & Estimated Earnings in Excess if Billings 
        CAST(IFNULL(b.`Cost & Estimated Earnings in Excess of Billings`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Cost & Estimated Earnings in Excess of Billings`,

/* All Other Current Assets */ 
    CAST(IFNULL(b.`All Other Current Assets`,0) AS DECIMAL(15,2)) AS `All Other Current Assets`,
		-- CS All Other Current Assets 
        CAST(IFNULL(b.`All Other Current Assets`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS All Other Current Assets`,

/* Total Current Assets */ 
    CAST(IFNULL(b.`Total Current Assets`,0) AS DECIMAL(15,2)) AS `Total Current Assets`,
		-- CS Total Current Assets 
        CAST(IFNULL(b.`Total Current Assets`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Current Assets`,

/* Property, Plant & Equipment */ 
    CAST(IFNULL(b.`Property, Plant & Equipment (Gross)`,0) AS DECIMAL(15,2)) AS `Property, Plant & Equipment`,
		-- CS Property, Plant & Equipment
        CAST(IFNULL(b.`Property, Plant & Equipment (Gross)`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Property, Plant & Equipment`,

/* Less Accumulated Depreciation */ 
    CAST(IFNULL(b.`Accumulated Depreciation`,0) AS DECIMAL(15,2)) AS `Less Accumulated Depreciation`,
		-- CS Less Accumulated Depreciation
        CAST(IFNULL(b.`Accumulated Depreciation`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Less Accumulated Depreciation`,

/* Total Fixed Assets */ 
    CAST(IFNULL(b.`Total Fixed Assets (Net)`,0) AS DECIMAL(15,2)) AS `Total Fixed Assets`,
		-- CS Total Fixed Assets 
        CAST(IFNULL(b.`Total Fixed Assets (Net)`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Fixed Assets`,

/* Total Non-Current Assets */ 
    CAST(IFNULL(b.`Total Non-Current Assets`,0) AS DECIMAL(15,2)) AS `Total Non-Current Assets`,
		-- CS Total Non-Current Assets 
        CAST(IFNULL(b.`Total Non-Current Assets`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Non-Current Assets`,

/* Total Assets */ 
    CAST(IFNULL(b.`Total Assets`,0) AS DECIMAL(15,2)) AS `Total Assets`,
		-- CS Total Assets 
        CAST(IFNULL(b.`Total Assets`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Assets`,

/* Balance Sheet - Liabilities */ 

/* Accounts Payable - Trade */ 
    CAST(IFNULL(b.`Accounts Payable - Trade`,0) AS DECIMAL(15,2)) AS `Accounts Payable - Trade`,
		-- Accounts Payable - Trade 
        CAST(IFNULL(b.`Accounts Payable - Trade`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accounts Payable - Trade`,

/* Accounts Payable - Retention */ 
    CAST(IFNULL(b.`Accounts Payable - Retention`,0) AS DECIMAL(15,2)) AS `Accounts Payable - Retention`,
		-- CS Accounts Payable - Retention 
        CAST(IFNULL(b.`Accounts Payable - Retention`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accounts Payable - Retention`,

/* Accounts Payable - Other */     
    CAST(IFNULL(b.`Accounts Payable - Other`,0) AS DECIMAL(15,2)) AS `Accounts Payable - Other`,
		-- CS Accounts Payable - Other 
        CAST(IFNULL(b.`Accounts Payable - Other`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accounts Payable - Other`,

/* Total Accounts Payable */ 
    CAST(IFNULL(b.`Total Accounts Payable`,0) AS DECIMAL(15,2)) AS `Total Accounts Payable`,
		-- CS Total Accounts Payable 
        CAST(IFNULL(b.`Total Accounts Payable`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Accounts Payable`,

/* Billings in Excess of Costs & Estimated Earnings */ 
    CAST(IFNULL(b.`Billings in Excess of Costs & Estimated Earnings`,0) AS DECIMAL(15,2)) AS `Billings in Excess of Costs & Estimated Earnings`,
		-- CS Billings in Excess of Costs & Estimated Earnings
        CAST(IFNULL(b.`Billings in Excess of Costs & Estimated Earnings`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Billings in Excess of Costs & Estimated Earnings`,

/* Accrued Expenses */ 
    CAST(IFNULL(b.`Accrued Expenses`,0) AS DECIMAL(15,2)) AS `Accrued Expenses`,
		-- CS Accrued Expenses
        CAST(IFNULL(b.`Accrued Expenses`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Accrued Expenses`,

/* Short-Term Notes Payable */     
    CAST(IFNULL(b.`Short-Term Notes Payable`,0) AS DECIMAL(15,2)) AS `Short-Term Notes Payable`,
		-- CS Short-Term Notes Payable 
        CAST(IFNULL(b.`Short-Term Notes Payable`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Short-Term Notes Payable`,

/* Revolving Credit Line */     
    CAST(IFNULL(b.`Revolving Credit Line`,0) AS DECIMAL(15,2)) AS `Revolving Credit Line`,
		-- CS Revolving Credit Line
        CAST(IFNULL(b.`Revolving Credit Line`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Revolving Credit Line`,

/* Current Maturities - Long-Term Debt */        
    CAST(IFNULL(b.`Current Maturities - Long-Term Debt`,0) AS DECIMAL(15,2)) AS `Current Maturities - Long-Term Debt`,
		-- CS Current Maturities - Long-Term Debt
        CAST(IFNULL(b.`Current Maturities - Long-Term Debt`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Current Maturities - Long-Term Debt`,

/* All Other Current Liabilities */ 
    CAST(IFNULL(b.`All Other Current Liabilities`,0) AS DECIMAL(15,2)) AS `All Other Current Liabilities`,
		-- CS All Other Current Liabilities
        CAST(IFNULL(b.`All Other Current Liabilities`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS All Other Current Liabilities`,

/* Total Current Liabilities */ 
    CAST(IFNULL(b.`Total Current Liabilities`,0) AS DECIMAL(15,2)) AS `Total Current Liabilities`,
		-- CS Total Current Liabilities 
        CAST(IFNULL(b.`Total Current Liabilities`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Current Liabilities`,

/* Long-Term Debt (Net of Current Portion) */ 
    CAST(IFNULL(b.`Long-Term Debt (Net of Current Portion)`,0) AS DECIMAL(15,2)) AS `Long-Term Debt (Net of Current Portion)`,
		-- CS Long-Term Debt (Net of Current Portion)
        CAST(IFNULL(b.`Long-Term Debt (Net of Current Portion)`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Long-Term Debt (Net of Current Portion)`,

/* All Other Non-Current Liabilities */ 
    CAST(IFNULL(b.`All Other Non-Current Liabilities`,0)+IFNULL(b.`Deferred Taxes`,0) AS DECIMAL(15,2)) AS `All Other Non-Current Liabilities`,
		-- CS All Other Non-Current Liabilities
        CAST((IFNULL(b.`All Other Non-Current Liabilities`,0)+IFNULL(b.`Deferred Taxes`,0))/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS All Other Non-Current Liabilities`,

/* Total Liabilities */ 
    CAST(IFNULL(b.`Total Liabilities`,0) AS DECIMAL(15,2)) AS `Total Liabilities`,
		-- CS Total Liabilities 
         CAST(IFNULL(b.`Total Liabilities`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Liabilities`,

/* Shareholder's Equity */ 
    CAST(IFNULL(b.`Shareholder/Member/Partner Equity`,0) AS DECIMAL(15,2)) AS `Shareholder's Equity`,
		-- CS Shareholder's Equity
        CAST(IFNULL(b.`Shareholder/Member/Partner Equity`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Shareholder's Equity`,

/* Total Liabilities and Shareholder's Equity */ 
    CAST(IFNULL(b.`Total Liabilities and Equity`,0) AS DECIMAL(15,2)) AS `Total Liabilities and Shareholder's Equity`,
		-- CS Total Liabilities and Shareholder's Equity
        CAST(IFNULL(b.`Total Liabilities and Equity`,0)/IFNULL(b.`Total Assets`,0) AS DECIMAL(10,6)) AS `CS Total Liabilities and Shareholder's Equity`,

/* Income Statement */ 

/* Revenues */ 
    CAST(IFNULL(b.`Revenues`,0) AS DECIMAL(15,2)) AS `Revenues`,
		-- CS Revenues 
        CAST(IFNULL(b.`Revenues`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Revenues`,

/* Total Direct Costs */ 
    CAST(IFNULL(b.`Total Direct Costs`,0) AS DECIMAL(15,2)) AS `Total Direct Costs`,
		-- Total Direct Costs 
        CAST(IFNULL(b.`Total Direct Costs`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Total Direct Costs`,

/* Labor Costs */ 
    CAST(IFNULL(b.`Labor Cost`,0) AS DECIMAL(15,2)) AS `Labor Costs`,
		-- CS Labor Costs 
        CAST(IFNULL(b.`Labor Cost`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Labor Costs`,

/* Material Costs */ 
    CAST(IFNULL(b.`Material Cost`,0) AS DECIMAL(15,2)) AS `Material Costs`,
		-- CS Material Costs 
        CAST(IFNULL(b.`Material Cost`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Material Costs`,

/* Equipment Costs */ 
    CAST(IFNULL(b.`Equipment Cost`,0) AS DECIMAL(15,2)) AS `Equipment Costs`,
		-- CS Equipment Costs 
        CAST(IFNULL(b.`Equipment Cost`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Equipment Costs`, 

/* Subcontracts Costs */ 
    CAST(b.`Subcontracts Cost` AS DECIMAL(15,2)) AS `Subcontracts Costs`,
		-- CS Subcontracts Costs
		CAST(b.`Subcontracts Cost`/b.`Revenues` AS DECIMAL(10,6)) AS `CS Subcontracts Costs`,

/* Other Costs */ 
    CAST(IFNULL(b.`Other Direct Costs`,0) AS DECIMAL(15,2)) AS `Other Direct Costs`,
		-- CS Other Direct Costs
        CAST(IFNULL(b.`Other Direct Costs`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Other Direct Costs`,

/* Gross Profit */ 
    CAST(IFNULL(b.`Gross Profit`,0) AS DECIMAL(15,2)) AS `Gross Profit`,
		-- CS Gross Profit
        CAST(IFNULL(b.`Gross Profit`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Gross Profit`,

/* Total Operating Expenses */ 
    CAST(IFNULL(b.`Total Operating Expenses`,0) AS DECIMAL(15,2)) AS `Operating Expenses (SG&A)`,
		-- CS Total Operating Expenses 
        CAST(IFNULL(b.`Total Operating Expenses`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Operating Expenses (SG&A)`,

/* Operating Margin */ 
    CAST(IFNULL(b.`Gross Profit`,0)-IFNULL(b.`Total Operating Expenses`,0) AS DECIMAL(15,2)) AS `Operating Margin`,
		-- CS Operating Margin 
        CAST((IFNULL(b.`Gross Profit`,0)-IFNULL(b.`Total Operating Expenses`,0))/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Operating Margin`,

/* Other Income or Expense */ 
    CAST(IFNULL(b.`Other Income/ (Loss)`,0)+IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)+IFNULL(b.`Other Expenses`,0)+IFNULL(b.`Joint Venture Income`,0)+
    IFNULL(b.`Interest Expense`,0)+IFNULL(b.`Interest & Dividend Income`,0) AS DECIMAL(15,2)) AS `Other Income or Expense`,
		-- CS Other Income or Expense
        CAST((IFNULL(b.`Other Income/ (Loss)`,0)+IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)+IFNULL(b.`Other Expenses`,0)+IFNULL(b.`Joint Venture Income`,0)+
		IFNULL(b.`Interest Expense`,0)+IFNULL(b.`Interest & Dividend Income`,0))/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Other Income or Expense`,

/* Net Income/(Loss) Before Taxes */ 
    CAST(((IFNULL(b.`Gross Profit`,0)-IFNULL(b.`Total Operating Expenses`,0)) + ((IFNULL(b.`Other Income/ (Loss)`,0)+
    IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)-IFNULL(b.`Other Expenses`,0)+IFNULL(b.`Joint Venture Income`,0)- 
    IFNULL(b.`Interest Expense`,0)+IFNULL(b.`Interest & Dividend Income`,0)) + IFNULL(b.`income_from_discontinued_operations`,0))) 
    AS DECIMAL(15,2)) AS `Net Income/(Loss) Before Taxes`,
		-- CS Net Income/(Loss) Before Taxes
        CAST((((IFNULL(b.`Gross Profit`,0)/IFNULL(b.`Revenues`,0))-(IFNULL(b.`Total Operating Expenses`,0)/IFNULL(b.`Revenues`,0))) + 
        (((IFNULL(b.`Other Income/ (Loss)`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)/IFNULL(b.`Revenues`,0))-
        (IFNULL(b.`Other Expenses`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Joint Venture Income`,0)/IFNULL(b.`Revenues`,0))-
        (IFNULL(b.`Interest Expense`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Interest & Dividend Income`,0)/IFNULL(b.`Revenues`,0)))+
        (IFNULL(b.`income_from_discontinued_operations`,0)/IFNULL(b.`Revenues`,0)))) AS DECIMAL(10,6)) AS `CS Net Income/(Loss) Before Taxes`,

/* Income Taxes */ 
    CAST(IFNULL(b.`Income Taxes`,0) AS DECIMAL(15,2)) AS `Income Taxes`,
		-- CS Income Taxes 
		CAST(IFNULL(b.`Income Taxes`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Income Taxes`,

/* Net Income/(Loss) After Taxes */ 
    CAST(((IFNULL(b.`Gross Profit`,0)-IFNULL(b.`Total Operating Expenses`,0)) + ((IFNULL(b.`Other Income/ (Loss)`,0)+
    IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)-IFNULL(b.`Other Expenses`,0)+IFNULL(b.`Joint Venture Income`,0)- 
    IFNULL(b.`Interest Expense`,0)+IFNULL(b.`Interest & Dividend Income`,0)) + IFNULL(b.`income_from_discontinued_operations`,0))-IFNULL(b.`Income Taxes`,0)) 
    AS DECIMAL(15,2)) AS `Net Income/(Loss) After Taxes`,
		-- CS Net Income/(Loss) After Taxes
        CAST((((IFNULL(b.`Gross Profit`,0)/IFNULL(b.`Revenues`,0))-(IFNULL(b.`Total Operating Expenses`,0)/IFNULL(b.`Revenues`,0))) + 
        (((IFNULL(b.`Other Income/ (Loss)`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)/IFNULL(b.`Revenues`,0))-
        (IFNULL(b.`Other Expenses`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Joint Venture Income`,0)/IFNULL(b.`Revenues`,0))-
        (IFNULL(b.`Interest Expense`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Interest & Dividend Income`,0)/IFNULL(b.`Revenues`,0)))+
        (IFNULL(b.`income_from_discontinued_operations`,0)/IFNULL(b.`Revenues`,0)))-(IFNULL(b.`Income Taxes`,0)/IFNULL(b.`Revenues`,0))) AS DECIMAL(10,6)) AS `CS Net Income/(Loss) After Taxes`,

/* Non-Controlling Interest in Net Income/(Loss) */ 
	CAST(IFNULL(b.`Non-Controlling Interest`,0) AS DECIMAL(15,2)) AS `Non-Controlling Interest in Net Income/(Loss)`,
		-- CS Non-Controlling Interest in Net Income/(Loss)
		CAST(IFNULL(b.`Non-Controlling Interest`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Non-Controlling Interest in Net Income/(Loss)`,

/* Depreciation / Amortization Expense */ 
	CAST(IFNULL(b.`Depreciation & Amortization`,0) AS DECIMAL(15,2)) AS `Depreciation / Amortization Expense`,
		-- CS Depreciation / Amortization Expense
        CAST(IFNULL(b.`Depreciation & Amortization`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Depreciation / Amortization Expense`,

/* EBITDA */ 
    CAST(((IFNULL(b.`Gross Profit`,0) - IFNULL(b.`Total Operating Expenses`,0)) + ((IFNULL(b.`Other Income/ (Loss)`,0) +
    IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0) - IFNULL(b.`Other Expenses`,0) + IFNULL(b.`Joint Venture Income`,0) +
    IFNULL(b.`Interest & Dividend Income`,0)) + IFNULL(b.`Depreciation & Amortization`,0) + IFNULL(b.`income_from_discontinued_operations`,0))) 
    AS DECIMAL(15,2)) AS `EBITDA`,
		-- CS EBITDA
        CAST((((IFNULL(b.`Gross Profit`,0)/IFNULL(b.`Revenues`,0))-(IFNULL(b.`Total Operating Expenses`,0)/IFNULL(b.`Revenues`,0))) + 
        (((IFNULL(b.`Other Income/ (Loss)`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)/IFNULL(b.`Revenues`,0))-
        (IFNULL(b.`Other Expenses`,0)/IFNULL(b.`Revenues`,0))+(IFNULL(b.`Joint Venture Income`,0)/IFNULL(b.`Revenues`,0))+
        (IFNULL(b.`Interest & Dividend Income`,0)/IFNULL(b.`Revenues`,0))) + (IFNULL(b.`Depreciation & Amortization`,0)/IFNULL(b.`Revenues`,0))+
        (IFNULL(b.`income_from_discontinued_operations`,0)/IFNULL(b.`Revenues`,0)))) 
        AS DECIMAL(10,6)) AS `CS EBITDA`,

/* Statement of Cash Flows */ 

/* Other Adjustments to Net Income */ 
	CAST(IFNULL(b.`Other Adjustments to Reconcile Net Income`,0) AS DECIMAL(15,2)) AS `Other Adjustments to Net Income`,
		-- CS Other Adjustments to Net Income
        CAST(IFNULL(b.`Other Adjustments to Reconcile Net Income`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Other Adjustments to Net Income`,

/* Total Adjustments */ 
    CAST(IFNULL(b.`Total Adjustments`,0) AS DECIMAL(15,2)) AS `Total Adjustments`,
		-- CS Total Adjustment 
        CAST(IFNULL(b.`Total Adjustments`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Total Adjustments`,

/* Cash Flows from Operating Activities */ 
    CAST(IFNULL(b.`Cash Flows from Operating Activities`,0) AS DECIMAL(15,2)) AS `Cash Flows from Operating Activities`,
		-- CS Cash Flows from Operating Activities
        CAST(IFNULL(b.`Cash Flows from Operating Activities`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Cash Flows from Operating Activities`,

/* Cash Flows from Investing Activities */ 
    CAST(IFNULL(b.`Cash Flows from Investing Activities`,0) AS DECIMAL(15,2)) AS `Cash Flows from Investing Activities`,
    -- CS Cash Flows from Investing Activities  
	CAST(IFNULL(b.`Cash Flows from Investing Activities`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Cash Flows from Investing Activities`,

/* Cash Flows from Financing Activities */ 
    CAST(IFNULL(b.`Cash Flows from Financing Activities`,0) AS DECIMAL(15,2)) AS `Cash Flows from Financing Activities`,
		-- CS Cash Flows from Financing Activities
        CAST(IFNULL(b.`Cash Flows from Financing Activities`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Cash Flows from Financing Activities`,

/* Cash Inflows */ 
    CAST(IFNULL(b.`Cash Inflows`,0) AS DECIMAL(15,2)) AS `Cash Inflows`,
		-- CS Cash Inflows
        CAST(IFNULL(b.`Cash Inflows`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Cash Inflows`,

/* Cash Outflows */ 
    CAST(IFNULL(b.`Cash Outflows`,0) AS DECIMAL(15,2)) AS `Cash Outflows`,
		-- CS Cash Outflows
        CAST(IFNULL(b.`Cash Outflows`,0)/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Cash Outflows`,

/* Net Increase (Decrease) in Cash */ 
    CAST(IFNULL(b.`Cash Inflows`,0)-IFNULL(b.`Cash Outflows`,0) AS DECIMAL(15,2)) AS `Net Increase (Decrease) in Cash`,
		-- CS Net Increase (Decrease) in Cash
        CAST((IFNULL(b.`Cash Inflows`,0)-IFNULL(b.`Cash Outflows`,0))/IFNULL(b.`Revenues`,0) AS DECIMAL(10,6)) AS `CS Net Increase (Decrease) in Cash`,

/* Cash at Beginning of Year */ 
    
/* Cash at End of Year */
    
/* Financial Ratios */ 

    -- Current Ratio
    CAST(IFNULL(a.`Current Ratio`,0) AS DECIMAL (10,6)) AS `Current Ratio`,

    -- Quick Ratio
    CAST(IFNULL(a.`Quick Ratio`,0) AS DECIMAL (10,6)) AS `Quick Ratio`,

	-- Cash Ratio
	CAST(((IFNULL(b.`Cash & Cash Equivalents`,0)+IFNULL(b.`Marketable Securities`,0))/ IFNULL(b.`Total Current Liabilities`,0))
	AS DECIMAL(10,6)) AS `Cash Ratio`,

    -- Debt to Equity
    CAST(IFNULL(a.`Total Debt to Equity`,0) AS DECIMAL (10,6)) AS `Debt to Equity`,
    
    -- Return on Equity
    CAST(( 
		((IFNULL(b.`Gross Profit`,0)-IFNULL(b.`Total Operating Expenses`,0))+(IFNULL(b.`Other Income/ (Loss)`,0)+
		IFNULL(b.`Gain/ (Loss) on Sale of Assets`,0)+IFNULL(b.`Other Expenses`,0)+IFNULL(b.`Joint Venture Income`,0)+
        IFNULL(b.`Interest Expense`,0)+IFNULL(b.`Interest & Dividend Income`,0)+IFNULL(b.`Income Taxes`,0)+
        IFNULL(b.`Non-Controlling Interest`,0)))
        /	
		(IFNULL(b.`Shareholder/Member/Partner Equity`,0))) 
	AS DECIMAL(10,6)) AS `Return on Equity`,
    
    -- Return on Assets
    CAST(IFNULL(a.`Return on Assets`,0) AS DECIMAL (10,6)) AS `Return on Assets`,

	-- Return on Capital Employed
    CAST(
    ((IFNULL(b.`Gross Profit`,0)-(IFNULL(b.`Total Operating Expenses`,0)))/(IFNULL(b.`Total Assets`,0)-IFNULL(b.`Total Current Liabilities`,0)))
	AS DECIMAL (10,6)) AS `Return on Capital Employed`,
    
    -- Overbillings to Underbillings
    CAST(IFNULL(a.`Overbillings to Underbillings`,0) AS DECIMAL(10,6)) AS `Overbillings to Underbillings`,

    -- Gross Profit Margin
    CAST(a.`Gross Profit Margin` AS DECIMAL(10,6)) AS `Gross Profit Margin`,
    
	-- EBIT Margin
    CAST(((IFNULL(b.`Gross Profit`,0)-(IFNULL(b.`Total Operating Expenses`,0)))/(IFNULL(b.`Revenues`,0)))
	AS DECIMAL(10,6)) AS `EBIT Margin`,

    -- EBITDA Margin
    CAST(IFNULL(a.`EBITDA Margin`,0) AS DECIMAL(10,6)) AS `EBITDA Margin`,
    
    -- Overhead Margin 
    CAST(
    (IFNULL(b.`Total Operating Expenses`,0)/IFNULL(a.`Revenues`,0)) 
    AS DECIMAL(10,6)) AS `Overhead Margin`,

    -- Net Profit Margin
    CAST(IFNULL(a.`Net Profit Margin`,0) AS DECIMAL(10,6)) AS `Net Profit Margin`,

    -- Return on Working Capital
    CAST(IFNULL(a.`Return on Working Capital`,0) AS DECIMAL(10,6)) AS `Return on Working Capital`,

    -- Return on Net Assets
    CAST(IFNULL(a.`Return on Net Assets`,0) AS DECIMAL(10,6)) AS `Return on Net Assets`,

    -- Current Assets to Total Assets
    CAST(IFNULL(a.`Current Assets to Total Assets`,0) AS DECIMAL(10,6)) AS `Current Assets to Total Assets`,

    -- Working Capital Turnover
    CAST((IFNULL(b.`Revenues`,0)/(IFNULL(b.`Total Current Assets`,0)-IFNULL(b.`Total Current Liabilities`,0)))
    AS DECIMAL(10,6)) AS `Working Capital Turnover`,

    -- Total Assets to Revenue
    CAST(IFNULL(a.`Total Assets to Revenue`,0) AS DECIMAL(10,6)) AS `Total Assets to Revenue`,

    -- Days of Cash-on-Hand
    CAST(IFNULL(a.`Days of Cash-on-Hand`,0) AS DECIMAL(10,6)) AS `Days of Cash-on-Hand`,

    -- Days of Underbillings
    CAST(IFNULL(a.`Days of Underbillings`,0) AS DECIMAL(10,6)) AS `Days of Underbillings`,

    -- Days of Overbillings
    CAST(IFNULL(a.`Days of Overbillings`,0) AS DECIMAL(10,6)) AS `Days of Overbillings`,

    -- Days of Accounts Receivable
    CAST(IFNULL(a.`Days of Accounts Receivable`,0) AS DECIMAL(10,6)) AS `Days of Accounts Receivable`,

    -- Days of Accounts Receivable (less Retention)
    CAST(IFNULL(a.`Days of Accounts Receivable (less AR Retention)`,0) AS DECIMAL(10,6)) AS `Days of Accounts Receivable (less Retention)`,

    -- Days of Accounts Payable
    CAST(IFNULL(a.`Days of Accounts Payable`,0) AS DECIMAL(10,6)) AS `Days of Accounts Payable`,

    -- Days of Accounts Payable (less Retention)
    CAST(IFNULL(a.`Days of Accounts Payable (less AP Retention)`,0) AS DECIMAL(10,6)) AS `Days of Accounts Payable (less Retention)`,

    -- Fixed Assets (net) to Equity
    CAST(IFNULL(a.`Fixed Assets (net) to Equity`,0) AS DECIMAL(10,6)) AS `Fixed Assets (net) to Equity`,

    -- Equity Multiplier
    CAST(IFNULL(a.`Equity Multiplier`,0) AS DECIMAL(10,6)) AS `Equity Multiplier`,

    -- Current Liabilities to Equity
    CAST(IFNULL(a.`Current Liabilities to Equity`,0) AS DECIMAL(10,6)) AS `Current Liabilities to Equity`,

    -- Total Liabilities to Equity
    CAST(IFNULL(a.`Total Debt to Equity`,0) AS DECIMAL(10,6)) AS `Total Liabilities to Equity`,

    -- Equity to Overhead
    CAST(IFNULL(a.`Equity to Overhead`,0) AS DECIMAL(10,6)) AS `Equity to Overhead`,

    -- Underbillings to Equity
    CAST(IFNULL(a.`Underbillings to Equity`,0) AS DECIMAL(10,6)) AS `Underbillings to Equity`,

    -- Backlog to Equity
    CAST(a.`Backlog to Equity` AS DECIMAL(10,6)) AS `Backlog to Equity`,

    -- Overhead to Revenue
    CAST(IFNULL(a.`Overhead to Revenue`,0) AS DECIMAL(10,6)) AS `Overhead to Revenue`,

    -- Overhead to Direct Costs
    CAST(IFNULL(a.`Overhead to Direct Costs`,0) AS DECIMAL(10,6)) AS `Overhead to Direct Costs`,

    -- Times Interest Earned 
    CAST(IFNULL(a.`Times Interest Earned`,0) AS DECIMAL(10,6)) AS `Times Interest Earned`,

    -- Accounts Payable to Revenue
    CAST(IFNULL(a.`Accounts Payable to Revenue`,0) AS DECIMAL(10,6)) AS `Accounts Payable to Revenue`,

    -- Working Capital to Revenue
	CAST(((IFNULL(b.`Total Current Assets`,0)-IFNULL(b.`Total Current Liabilities`,0))/IFNULL(b.`Revenues`,0))
	AS DECIMAL(10,6)) AS `Working Capital to Revenue`,
    
    -- Asset Turnover
    CAST(IFNULL(a.`Asset Turnover`,0) AS DECIMAL(10,6)) AS `Asset Turnover`,

    -- Equity Turnover
    CAST(IFNULL(a.`Equity Turnover`,0) AS DECIMAL(10,6)) AS `Equity Turnover`,

    -- Materials & Subcontracts to Labor Ratio
    -- Null value when ratio is greater than 2. When ratio is greater than 200% it is likely irrelevent to the type of contractor.
	IF(
		((IFNULL(b.`Material Cost`,0)+IFNULL(b.`Subcontracts Cost`,0))/IFNULL(b.`Labor Cost`,0)) > 2 OR
		((IFNULL(b.`Material Cost`,0)+IFNULL(b.`Subcontracts Cost`,0))/IFNULL(b.`Labor Cost`,0)) < -2,
		NULL,
		CAST(((IFNULL(b.`Material Cost`,0)+IFNULL(b.`Subcontracts Cost`,0))/IFNULL(b.`Labor Cost`,0)) AS DECIMAL(10,6))
	) AS `Materials & Subcontract to Labor Ratio`,

    -- Degree of Fixed Asset Newness
    CAST(IFNULL(a.`Degree of Fixed Asset Newness`,0) AS DECIMAL(10,6)) AS `Degree of Fixed Asset Newness`,

    -- Backlog to Working Capital 
    CAST(IFNULL(a.`Backlog to Working Capital`,0) AS DECIMAL(10,6)) AS `Backlog to Working Capital`,

    -- Months in Backlog
    CAST(IFNULL(a.`Months in Backlog`,0) AS DECIMAL(10,6)) AS `Months in Backlog`
    
    FROM FSA_ratio_cast AS a 
		INNER JOIN 
        FSA_account_cast AS b
			ON a.Data_Key__c = b.Data_Key__c
			AND a.`Year` = b.`Year`
		LEFT JOIN 
        RMA_Master_full_cast AS c
			ON a.`NaicsCode` = REPLACE(c.`NAICS`,"P","")
            AND b.`Year` = c.`Year`
		LEFT JOIN SF_company_peer_groups d 
			ON a.Data_Key__c = d.PG_Company_ID
		LEFT JOIN Company_Alias e
			ON a.Data_Key__c = e.Data_Key__c
                
    GROUP BY a.Data_Key__c, `Company Name`, `Company Alias`, `Salesforce ID`, `Year`, `NAICS Code`,`NAICS Industry`, `Primary Sector`
;





