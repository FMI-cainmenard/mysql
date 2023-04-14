-- Use Insights Database
USE Insights;

-- Create RMA_FSA_full_view
CREATE OR REPLACE VIEW Insights.RMA_FSA_full_View AS 
SELECT 

/* Demographics */
-- Year
a.`Year`,
-- NAICS Code
CAST(a.`NAICS Code` AS CHAR(255)) AS `NAICS Code`,
-- RMA NAICS Industry
CAST(a.`NAICS Industry` AS CHAR(255)) AS `NAICS Industry`,
-- RMA Size Range
CAST(a.`RMA Size Range` AS CHAR(255)) AS `RMA Size Range`,
-- RMA Number of Statements
a.`Number of Statements`,
CAST(a.`Cash & Cash Equivalents` AS DECIMAL(10,3)) AS `Cash & Cash Equivalents`,
CAST(a.`Accounts Receivable - Trade` AS DECIMAL(10,3)) AS `Accounts Receivable - Trade`,
CAST(a.`Accounts Receivable - Current Retention` AS DECIMAL(10,3)) AS `Accounts Receivable - Current Retention`,
CAST(a.`Cost & Estimated Earnings in Excess of Billings` AS DECIMAL(10,3)) AS `Cost & Estimated Earnings in Excess of Billings`,
CAST(a.`Total Fixed Assets` AS DECIMAL(10,3)) AS `Total Fixed Assets`,
CAST(a.`Total Non-Current Assets` AS DECIMAL(10,3)) AS `Total Non-Current Assets`,
CAST(a.`Accounts Payable - Trade` AS DECIMAL(10,3)) AS `Accounts Payable - Trade`,
CAST(a.`Accounts Payable - Retention` AS DECIMAL(10,3)) AS `Accounts Payable - Retention`,
CAST(a.`Billings in Excess of Costs & Estimated Earnings` AS DECIMAL(10,3)) AS `Billings in Excess of Costs & Estimated Earnings`,
CAST(a.`Short-Term Notes Payable` AS DECIMAL(10,3)) AS `Short-Term Notes Payable`,
CAST(a.`Current Maturities - Long-Term Debt` AS DECIMAL(10,3)) AS `Current Maturities - Long-Term Debt`,
CAST(a.`Long-Term Debt (Net of Current Portion)` AS DECIMAL(10,3)) AS `Long-Term Debt (Net of Current Portion)`,
CAST(a.`Shareholder's Equity` AS DECIMAL(10,3)) AS `Shareholder's Equity`,
CAST(a.`Total Liabilities and Shareholder's Equity` AS DECIMAL(10,3)) AS `Total Liabilities and Shareholder's Equity`,
CAST(a.`Revenues` AS DECIMAL(10,3)) AS `Revenues`,
CAST(a.`Overhead to Revenue` AS DECIMAL(10,3)) AS `Overhead to Revenue`,
CAST(a.`Operating Profit Margin` AS DECIMAL(10,3)) AS `Operating Profit Margin`,
CAST(a.`Other Income or Expense` AS DECIMAL(10,3)) AS `Other Income or Expense`,
CAST(a.`Net Profit Margin` AS DECIMAL(10,3)) AS `Net Profit Margin`,
CAST(a.`Current Ratio` AS DECIMAL(10,3)) AS `Current Ratio`,
CAST(a.`Quick Ratio` AS DECIMAL(10,3)) AS `Quick Ratio`,
CAST((a.`Cash & Cash Equivalents`/a.`Total Current Liabilities`) AS DECIMAL (10,3)) AS `Cash Ratio`,
CAST(a.`Total Liabilities to Equity` AS DECIMAL(10,3)) AS `Total Liabilities to Equity`,
CAST(a.`Return on Equity` AS DECIMAL(10,3)) AS `Return on Equity`,
CAST(a.`Return on Assets` AS DECIMAL(10,3)) AS `Return on Assets`,
CAST(a.`Gross Profit Margin` AS DECIMAL(10,3)) AS `Gross Profit Margin`,
CAST(a.`Current Assets to Total Assets` AS DECIMAL(10,3)) AS `Current Assets to Total Assets`,
CAST(a.`Days of Cash-on-Hand` AS DECIMAL(10,6)) AS `Days of Cash-on-Hand`,
CAST(a.`Days of Underbillings` AS DECIMAL(10,6)) AS `Days of Underbillings`,
CAST(a.`Days of Overbillings` AS DECIMAL(10,6)) AS `Days of Overbillings`,
CAST(a.`Days of Accounts Receivable` AS DECIMAL(10,6)) AS `Days of Accounts Receivable`,
CAST(a.`Days of Accounts Payable` AS DECIMAL(10,6)) AS `Days of Accounts Payable`,
-- Fixed Assets (net) to Equity
CAST(IFNULL(IFNULL(a.`Total Fixed Assets`,0) / IFNULL(a.`Shareholder's Equity`,0),0) AS DECIMAL(10,3)) AS `Fixed Assets (net) to Equity`,

-- Equity Multiplier 
CAST(
IFNULL(IFNULL(a.`Total Assets`,0)/IFNULL(a.`Shareholder's Equity`,0),0)
AS DECIMAL(10,3)) AS `Equity Multiplier`,

CAST(a.`Times Interest Earned` AS DECIMAL(10,3)) AS `Times Interest Earned`,
CAST(a.`Working Capital Turnover` AS DECIMAL(10,3)) AS `Working Capital Turnover`,
CAST(a.`Asset Turnover` AS DECIMAL(10,3)) AS `Asset Turnover`,
CAST(a.`Total Liquid Assets` AS DECIMAL(10,3)) AS `Total Liquid Assets`,
CAST(a.`Total Accounts Receivable` AS DECIMAL(10,3)) AS `Total Accounts Receivable`,
CAST(a.`Total Accounts Payable` AS DECIMAL(10,3)) AS `Total Accounts Payable`,
CAST(a.`Total Liabilities` AS DECIMAL(10,3)) AS `Total Liabilities`,
CAST(a.`Total Direct Costs` AS DECIMAL(10,3)) AS `Total Direct Costs`,
CAST(a.`Total Current Assets` AS DECIMAL(10,3)) AS `Total Current Assets`,
CAST(a.`Inventory` AS DECIMAL(10,3)) AS `Inventory`,
CAST(a.`All Other Non-Current Assets` AS DECIMAL(10,3)) AS `All Other Non-Current Assets`,
CAST(a.`All Other Current Assets` AS DECIMAL(10,3)) AS `All Other Current Assets`,
CAST(a.`Total Assets` AS DECIMAL(10,3)) AS `Total Assets`,
CAST(a.`All Other Current Liabilities` AS DECIMAL(10,3)) AS `All Other Current Liabilities`,
CAST(a.`Total Current Liabilities` AS DECIMAL(10,3)) AS `Total Current Liabilities`,
CAST(a.`All Other Non-Current Liabilities` AS DECIMAL(10,3)) AS `All Other Non-Current Liabilities`,
CAST(a.`Total Liabilities & Net Worth` AS DECIMAL(10,3)) AS `Total Liabilities & Net Worth`,
CAST(a.`Gross Profit` AS DECIMAL(10,3)) AS `Gross Profit`,
CAST(a.`Overbillings to Underbillings` AS DECIMAL(10,3)) AS `Overbillings to Underbillings`,
CAST(a.`Return on Working Capital` AS DECIMAL(10,3)) AS `Return on Working Capital`,
CAST(a.`Return on Net Assets` AS DECIMAL(10,3)) AS `Return on Net Assets`,
CAST(a.`Return on Capital Employed` AS DECIMAL(10,3)) AS `Return on Capital Employed`,
CAST(a.`Working Capital to Revenue` AS DECIMAL(10,3)) AS `Working Capital to Revenue`,
CAST(a.`Total Assets to Revenue` AS DECIMAL(10,3)) AS `Total Assets to Revenue`,
CAST(a.`Current Liabilities to Equity` AS DECIMAL(10,3)) AS `Current Liabilities to Equity`,
CAST(a.`Equity to Overhead` AS DECIMAL(10,3)) AS `Equity to Overhead`,
CAST(a.`Underbillings to Equity` AS DECIMAL(10,3)) AS `Underbillings to Equity`,
CAST(a.`Overhead to Direct Costs` AS DECIMAL(10,3)) AS `Overhead to Direct Costs`,
CAST(a.`Accounts Payable to Revenue` AS DECIMAL(10,3)) AS `Accounts Payable to Revenue`,
CAST(a.`Profit Before Taxes` AS DECIMAL(10,3)) AS `Profit Before Taxes`,

-- Equity Turnover
CAST(a.`Equity Turnover` AS DECIMAL(10,3)) AS `Equity Turnover`,

-- Overhead Margin
CAST(IFNULL(IFNULL(a.`Total Operating Expenses`,0)/IFNULL(a.`Revenues`,0),0) 
AS DECIMAL(10,3)) AS `Overhead Margin`,

CAST(a.`Net Income/(Loss) Before Taxes` AS DECIMAL(10,3)) AS `Net Income/(Loss) Before Taxes`,
CAST(a.`Debt to Equity` AS DECIMAL(10,3)) AS `Debt to Equity`,
CAST(a.`Operating Margin` AS DECIMAL(10,3)) AS `Operating Margin`,

-- Operating Income (EBIT)
CAST(IFNULL(IFNULL(a.`Gross Profit`,0)-IFNULL(a.`Total Operating Expenses`,0),0) 
AS DECIMAL(10,3)) AS `Operating Income (EBIT)`,

CAST(a.`Total Operating Expenses` AS DECIMAL(10,3)) AS `Total Operating Expenses`

FROM Insights.RMA_FSA_full AS a
;

SELECT * FROM RMA_FSA_full_View;