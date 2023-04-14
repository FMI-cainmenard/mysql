
USE Insights;

CREATE OR REPLACE VIEW FSA_View AS
SELECT 
-- Company Profile
    a.`Name` AS `Company Name`,
    a.Data_Key__c AS `Company ID`,
    ca.`Alias` AS `Company Alias`,
    a.`Id` AS `Salesforce ID`,
    m.`fsa_year` AS `Year`,
    -- NAICS Code
    COALESCE(
        CASE 
            WHEN COALESCE(REPLACE(c.`NAICS Code`, 'P', ''), a.NAICSCode__c) IN ('335999', '423320') THEN '444100'
            WHEN COALESCE(REPLACE(c.`NAICS Code`, 'P', ''), a.NAICSCode__c) = '531210' THEN '236220'
            WHEN COALESCE(REPLACE(c.`NAICS Code`, 'P', ''), a.NAICSCode__c) = '484110' 
                AND COALESCE(c.`NAICS Industry`, a.NAICSDesc__c) IN ('Highway, Street, and Bridge Construction', 'Highway, Street & Bridge Construction') THEN '237310'
            WHEN COALESCE(REPLACE(c.`NAICS Code`, 'P', ''), a.NAICSCode__c) = '336992' THEN '236210'
            ELSE COALESCE(REPLACE(c.`NAICS Code`, 'P', ''), a.NAICSCode__c)
        END, 'NULL'
    ) AS `NAICS Code`,
    -- RMA NAICS Industry
COALESCE(
        CASE 
            WHEN COALESCE(c.`NAICS Industry`, a.NAICSDesc__c) IN (
                'Highway, Street, and Bridge Construction', 
                'Industrial Building', 
                'All Other Miscellaneous Electrical Equipment and Component Manufacturing', 
                'Brick, Stone, and Related Construction Material Merchant Wholesalers', 
                'Commercial and Institutional Building Construction', 
                'Plumbing, Heating, and Air-Conditioning Contractors', 
                'Water and Sewer Line and Related Structures Construction'
            ) THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(c.`NAICS Industry`, a.NAICSDesc__c), 
                'Highway, Street, and Bridge Construction', 'Highway, Street & Bridge Construction'), 
                'Industrial Building', 'Industrial Building Construction'), 
                'All Other Miscellaneous Electrical Equipment and Component Manufacturing', 'Building Material and Supplies Dealers'), 
                'Brick, Stone, and Related Construction Material Merchant Wholesalers', 'Building Material and Supplies Dealers'), 
                'Commercial and Institutional Building Construction', 'Commercial & Institutional Building Construction'), 
                'Plumbing, Heating, and Air-Conditioning Contractors', 'Plumbing, Heating, & Air-Conditioning'), 
                'Water and Sewer Line and Related Structures Construction', 'Water and Sewer Line & Related Structures Construction')
            ELSE COALESCE(c.`NAICS Industry`, a.NAICSDesc__c)
        END, 'NULL'
    ) AS `NAICS Industry`,
    a.Primary_Sector__c AS `Primary Sector`,
    pg.`Name` AS `Peer Group`, 
    COALESCE(pg2.`Name`, '') AS `Peer Group 2`,
    a.Peer_Group_Company_Status__c AS `Peer Group Status`, 
    a.X2nd_Peer_Group_Company_Status__c AS `Peer 2 Group Status`, 
    
-- Balance Sheet - Assets
	-- Cash & Cash Equivalents
	CAST(COALESCE((COALESCE(m.`cash_&_cash_equivalents`,0) + COALESCE(m.marketable_securities, 0)),0) AS DECIMAL(15,2)) AS `Cash & Cash Equivalents`,
		-- CS Cash & Cash Equivalents
        CAST(COALESCE(
        ((COALESCE(m.`cash_&_cash_equivalents`,0)/COALESCE(m.total_assets,0)) + (COALESCE(m.marketable_securities, 0))/COALESCE(m.total_assets,0)) 
        ,0) AS DECIMAL(10,6)) AS `CS Cash & Cash Equivalents`,
    -- Marketable Securities
	CAST((COALESCE(m.marketable_securities,0)) AS DECIMAL(15,2)) AS `Marketable Securities`,
		-- CS Marketable Securities
        CAST(COALESCE(((COALESCE(m.marketable_securities,0)/COALESCE(m.total_assets,0))),0) AS DECIMAL(10,6)) AS `CS Marketable Securities`,
	-- Total Liquid Assets
    CAST(COALESCE((COALESCE(m.marketable_securities,0)+COALESCE(m.`cash_&_cash_equivalents`,0)),0) AS DECIMAL(15,2)) AS `Total Liquid Assets`,
		-- CS Total Liquid Assets 
        CAST(COALESCE(((COALESCE(m.marketable_securities,0)/COALESCE(m.total_assets,0))+(COALESCE(m.`cash_&_cash_equivalents`,0))/COALESCE(m.total_assets,0)) 
        ,0) AS DECIMAL(10,6)) AS `CS Total Liquid Assets`,
	-- Accounts Receivable - Trade
    CAST((COALESCE(m.accounts_receivable_trade,0)) AS DECIMAL(15,2)) AS `Accounts Receivable - Trade`,
		-- CS Accounts Receivable - Trade
		CAST(COALESCE(((COALESCE(m.accounts_receivable_trade,0)/COALESCE(m.total_assets,0))),0) AS DECIMAL(10,6)) AS `CS Accounts Receivable - Trade`,
	-- Accounts Receivable - Other
    CAST(COALESCE(m.accounts_receivable_other,0) AS DECIMAL(15,2)) AS `Accounts Receivable - Other`,
		-- CS Accounts Receivable - Other
		CAST(COALESCE((COALESCE(m.accounts_receivable_other,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Accounts Receivable - Other`,
	-- Accounts Receivable - Current Retention
    CAST(COALESCE(m.accounts_receivable_retention,0) AS DECIMAL(15,2)) AS `Accounts Receivable - Current Retention`,
		-- CS Accounts Receivable - Current Retention
		CAST(COALESCE(COALESCE(m.accounts_receivable_retention,0)/COALESCE(m.total_assets,0),0) AS DECIMAL(10,6)) AS `CS Accounts Receivable - Current Retention`,
	-- Notes Receivable      
    CAST((COALESCE(m.notes_receivable,0)) AS DECIMAL(15,2)) AS `Notes Receivable`,
		-- CS Notes Receivable 
        CAST(COALESCE((COALESCE(m.notes_receivable,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Notes Receivable`,
	-- Total Accounts Receivable
    CAST(COALESCE(m.accounts_receivable_total,0) AS DECIMAL(15,2)) AS `Total Accounts Receivable`,
		-- CS Total Accounts Receivable
		CAST(COALESCE((COALESCE(m.accounts_receivable_total,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Accounts Receivable`,
	-- Inventory 
    CAST(COALESCE(m.inventory,0) AS DECIMAL(15,2)) AS `Inventory`,
		-- CS Inventory 
        CAST(COALESCE((COALESCE(m.inventory,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Inventory`,
	-- Cost & Estimated Earnings in Excess of Billings 
	CAST(COALESCE(m.`cost_&_estimated_earnings_in_excess_of_billings`,0) AS DECIMAL(15,2)) AS `Cost & Estimated Earnings in Excess of Billings`,
		-- CS Cost & Estimated Earnings in Excess if Billings 
        CAST(COALESCE((COALESCE(m.`cost_&_estimated_earnings_in_excess_of_billings`,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Cost & Estimated Earnings in Excess of Billings`,
	-- All Other Current Assets 
    CAST(COALESCE(m.all_other_current_assets,0) AS DECIMAL(15,2)) AS `All Other Current Assets`,
		-- CS All Other Current Assets 
        CAST(COALESCE((COALESCE(m.all_other_current_assets,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS All Other Current Assets`,
	-- Total Current Assets  
    CAST((COALESCE(m.total_current_assets,0)) AS DECIMAL(15,2)) AS `Total Current Assets`,
		-- CS Total Current Assets 
        CAST(COALESCE(COALESCE(m.total_current_assets,0)/COALESCE(m.total_assets,0),0) AS DECIMAL(10,6)) AS `CS Total Current Assets`,
	-- Property, Plant & Equipment  
    CAST(COALESCE(m.`property_plant_&_equipment_gross`,0) AS DECIMAL(15,2)) AS `Property, Plant & Equipment`,
		-- CS Property, Plant & Equipment
        CAST(COALESCE(COALESCE(m.`property_plant_&_equipment_gross`,0)/COALESCE(m.total_assets,0),0) AS DECIMAL(10,6)) AS `CS Property, Plant & Equipment`,
	-- Less Accumulated Depreciation  
    CAST(COALESCE(m.accumulated_depreciation,0) AS DECIMAL(15,2)) AS `Less Accumulated Depreciation`,
		-- CS Less Accumulated Depreciation
        CAST(COALESCE((COALESCE(m.accumulated_depreciation,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Less Accumulated Depreciation`,
	-- Total Fixed Assets  
    CAST(COALESCE(m.total_fixed_assets_net,0) AS DECIMAL(15,2)) AS `Total Fixed Assets`,
		-- CS Total Fixed Assets 
        CAST(COALESCE((COALESCE(m.total_fixed_assets_net,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Fixed Assets`,
	-- Total Non-Current Assets  
    CAST(COALESCE(m.total_non_current_assets,0) AS DECIMAL(15,2)) AS `Total Non-Current Assets`,
		-- CS Total Non-Current Assets 
        CAST(COALESCE((COALESCE(m.total_non_current_assets,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Non-Current Assets`,
	-- Total Assets  
    CAST(COALESCE(m.total_assets,0) AS DECIMAL(15,2)) AS `Total Assets`,
		-- CS Total Assets 
        CAST(COALESCE((COALESCE(m.total_assets,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Assets`,

-- Balance Sheet - Liabilities  
	-- Accounts Payable - Trade  
    CAST(COALESCE(m.accounts_payable_trade,0) AS DECIMAL(15,2)) AS `Accounts Payable - Trade`,
		-- Accounts Payable - Trade 
        CAST(COALESCE(COALESCE(m.accounts_payable_trade,0)/COALESCE(m.total_assets,0),0) AS DECIMAL(10,6)) AS `CS Accounts Payable - Trade`,
	-- Accounts Payable - Retention  
    CAST(COALESCE(m.accounts_payable_retention,0) AS DECIMAL(15,2)) AS `Accounts Payable - Retention`,
		-- CS Accounts Payable - Retention 
        CAST(COALESCE(COALESCE(m.accounts_payable_retention,0)/COALESCE(m.total_assets,0),0) AS DECIMAL(10,6)) AS `CS Accounts Payable - Retention`,
	-- Accounts Payable - Other      
    CAST(COALESCE(m.accounts_payable_other,0) AS DECIMAL(15,2)) AS `Accounts Payable - Other`,
		-- CS Accounts Payable - Other 
        CAST(COALESCE((COALESCE(m.accounts_payable_other,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Accounts Payable - Other`,
	-- Total Accounts Payable  
    CAST((COALESCE(m.accounts_payable_total,0)) AS DECIMAL(15,2)) AS `Total Accounts Payable`,
		-- CS Total Accounts Payable 
        CAST(COALESCE((COALESCE(m.accounts_payable_total,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Accounts Payable`,
	-- Billings in Excess of Costs & Estimated Earnings  
    CAST(COALESCE(m.`billings_in_excess_of_costs_&_estimated_earnings`,0) AS DECIMAL(15,2)) AS `Billings in Excess of Costs & Estimated Earnings`,
		-- CS Billings in Excess of Costs & Estimated Earnings
        CAST(COALESCE((COALESCE(m.`billings_in_excess_of_costs_&_estimated_earnings`,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Billings in Excess of Costs & Estimated Earnings`,
	-- Accrued Expenses  
    CAST((COALESCE(m.accrued_expenses,0)) AS DECIMAL(15,2)) AS `Accrued Expenses`,
		-- CS Accrued Expenses
        CAST(COALESCE((COALESCE(m.accrued_expenses,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Accrued Expenses`,
	-- Short-Term Notes Payable      
    CAST((COALESCE(m.short_term_notes_payable,0)) AS DECIMAL(15,2)) AS `Short-Term Notes Payable`,
		-- CS Short-Term Notes Payable 
        CAST(COALESCE((COALESCE(m.short_term_notes_payable,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Short-Term Notes Payable`,
	-- Revolving Credit Line      
    CAST((COALESCE(m.revolving_credit_line,0)) AS DECIMAL(15,2)) AS `Revolving Credit Line`,
		-- CS Revolving Credit Line
        CAST(COALESCE((COALESCE(m.revolving_credit_line,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Revolving Credit Line`,
	-- Current Maturities - Long-Term Debt         
    CAST((COALESCE(m.current_maturities_long_term_debt,0)) AS DECIMAL(15,2)) AS `Current Maturities - Long-Term Debt`,
		-- CS Current Maturities - Long-Term Debt
        CAST(COALESCE((COALESCE(m.current_maturities_long_term_debt,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Current Maturities - Long-Term Debt`,
	-- All Other Current Liabilities  
    CAST((COALESCE(m.all_other_current_liabilities,0)) AS DECIMAL(15,2)) AS `All Other Current Liabilities`,
		-- CS All Other Current Liabilities
        CAST(COALESCE((COALESCE(m.all_other_current_liabilities,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS All Other Current Liabilities`,
	-- Total Current Liabilities  
    CAST((COALESCE(m.total_current_liabilities,0)) AS DECIMAL(15,2)) AS `Total Current Liabilities`,
		-- CS Total Current Liabilities 
        CAST(COALESCE((COALESCE(m.total_current_liabilities,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Current Liabilities`,
	-- Long-Term Debt (Net of Current Portion)  
    CAST((COALESCE(m.long_term_debt_net_of_current_portion,0)) AS DECIMAL(15,2)) AS `Long-Term Debt (Net of Current Portion)`,
		-- CS Long-Term Debt (Net of Current Portion)
        CAST(COALESCE((COALESCE(m.long_term_debt_net_of_current_portion,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Long-Term Debt (Net of Current Portion)`,
	-- All Other Non-Current Liabilities  
    CAST((COALESCE(m.all_other_non_current_liabilities,0)) AS DECIMAL(15,2)) AS `All Other Non-Current Liabilities`,
		-- CS All Other Non-Current Liabilities
        CAST(COALESCE((COALESCE(m.all_other_non_current_liabilities,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS All Other Non-Current Liabilities`,
	-- Total Liabilities  
    CAST((COALESCE(m.total_liabilities,0)) AS DECIMAL(15,2)) AS `Total Liabilities`,
		-- CS Total Liabilities 
         CAST(COALESCE((COALESCE(m.total_liabilities,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Liabilities`,
	-- Shareholder's Equity  
    CAST((COALESCE(m.shareholder_member_partner_equity,0)) AS DECIMAL(15,2)) AS `Shareholder's Equity`,
		-- CS Shareholder's Equity
        CAST(COALESCE((COALESCE(m.shareholder_member_partner_equity,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Shareholder's Equity`,
	-- Total Liabilities and Shareholder's Equity  
    CAST((COALESCE(m.`total_liabilities_&_equity`,0)) AS DECIMAL(15,2)) AS `Total Liabilities and Shareholder's Equity`,
		-- CS Total Liabilities and Shareholder's Equity
        CAST(COALESCE((COALESCE(m.`total_liabilities_&_equity`,0)/COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `CS Total Liabilities and Shareholder's Equity`,

	--  Income Statement  
	--  Revenues  
    CAST((COALESCE(m.revenues,0)) AS DECIMAL(15,2)) AS `Revenues`,
		-- CS Revenues 
        CAST(COALESCE((COALESCE(m.revenues,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Revenues`,
	--  Total Direct Costs  
    CAST(COALESCE(m.total_direct_costs,0) AS DECIMAL(15,2)) AS `Total Direct Costs`,
		-- Total Direct Costs 
        CAST(COALESCE((COALESCE(m.total_direct_costs,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Total Direct Costs`,
	--  Labor Costs  
    CAST(COALESCE(m.labor_cost,0) AS DECIMAL(15,2)) AS `Labor Costs`,
		-- CS Labor Costs 
        CAST(COALESCE((COALESCE(m.labor_cost,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Labor Costs`,
	--  Material Costs  
    CAST(COALESCE(m.materials_cost,0) AS DECIMAL(15,2)) AS `Material Costs`,
		-- CS Material Costs 
        CAST(COALESCE((COALESCE(m.materials_cost,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Material Costs`,
	--  Equipment Costs  
    CAST(COALESCE(m.equipment_cost,0) AS DECIMAL(15,2)) AS `Equipment Costs`,
		-- CS Equipment Costs 
        CAST(COALESCE((COALESCE(m.equipment_cost,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Equipment Costs`, 
	--  Subcontracts Costs  
    CAST(COALESCE(m.subcontracts_cost,0) AS DECIMAL(15,2)) AS `Subcontracts Costs`,
		-- CS Subcontracts Costs
		CAST(COALESCE((COALESCE(m.subcontracts_cost,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Subcontracts Costs`,
	-- Other Costs  
    CAST(COALESCE(m.other_direct_COGS,0) AS DECIMAL(15,2)) AS `Other Direct Costs`,
		-- CS Other Direct Costs
        CAST(COALESCE(COALESCE(m.other_direct_COGS,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `CS Other Direct Costs`,
	-- Gross Profit  
    CAST((COALESCE(m.gross_profit,0)) AS DECIMAL(15,2)) AS `Gross Profit`,
		-- CS Gross Profit
        CAST(COALESCE(COALESCE(m.gross_profit,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `CS Gross Profit`,
	-- Total Operating Expenses  
    CAST((COALESCE(m.`total_SG&A`,0)) AS DECIMAL(15,2)) AS `Operating Expenses (SG&A)`,
		-- CS Total Operating Expenses 
        CAST(COALESCE(COALESCE(m.`total_SG&A`,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `CS Operating Expenses (SG&A)`,
    -- Operating Income (EBIT)  
    CAST(COALESCE(m.ebit,0) AS DECIMAL(15,2)) AS `Operating Income (EBIT)`,
		-- CS Operating Income (EBIT)
        CAST(COALESCE(COALESCE(m.ebit,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `CS Operating Income (EBIT)`,
	-- Other Income or Expense  
    CAST(COALESCE(
    COALESCE(m.other_income_loss,0)+COALESCE(m.gain_loss_on_sale_of_assets,0)+COALESCE(m.other_expenses,0)+COALESCE(m.joint_venture_income,0)+
    COALESCE(m.interest_expense,0)+COALESCE(m.`interest_&_dividend_income`,0) 
    ,0) AS DECIMAL(15,2)) AS `Other Income or Expense`,
		-- CS Other Income or Expense
        CAST(COALESCE((((COALESCE(m.other_income_loss,0)/COALESCE(m.revenues,0))+(COALESCE(m.gain_loss_on_sale_of_assets,0)/COALESCE(m.revenues,0))+(COALESCE(m.other_expenses,0)/COALESCE(m.revenues,0))+
        (COALESCE(m.joint_venture_income,0)/COALESCE(m.revenues,0))+(COALESCE(m.interest_expense,0)/COALESCE(m.revenues,0))+(COALESCE(m.`interest_&_dividend_income`,0))/COALESCE(m.revenues,0))) 
        ,0) AS DECIMAL(10,6)) AS `CS Other Income or Expense`,
    -- Net Income/(Loss) Before Taxes  
    CAST(COALESCE(m.net_income_loss_before_taxes,0) AS DECIMAL(15,2)) AS `Net Income/(Loss) Before Taxes`,
		-- CS Net Income/(Loss) Before Taxes
        CAST(COALESCE(COALESCE(m.net_income_loss_before_taxes,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `CS Net Income/(Loss) Before Taxes`,
    -- Income Taxes  
    CAST((COALESCE(m.provision_for_income_taxes,0)) AS DECIMAL(15,2)) AS `Income Taxes`,
		-- CS Income Taxes 
		CAST(COALESCE((COALESCE(m.provision_for_income_taxes,0)/COALESCE(m.revenues,0))
        ,0) AS DECIMAL(10,6)) AS `CS Income Taxes`,
    -- Net Income/(Loss) After Taxes  
    CAST(COALESCE(((COALESCE(m.gross_profit,0)-COALESCE(m.`total_SG&A`,0)) + ((COALESCE(m.other_income_loss,0)+
    COALESCE(m.gain_loss_on_sale_of_assets,0)-COALESCE(m.other_expenses,0)+COALESCE(m.joint_venture_income,0)- 
    COALESCE(m.interest_expense,0)+COALESCE(m.`interest_&_dividend_income`,0)) + COALESCE(m.income_from_discontinued_operations,0))-COALESCE(m.provision_for_income_taxes,0)) 
    ,0) AS DECIMAL(15,2)) AS `Net Income/(Loss) After Taxes`,
		-- CS Net Income/(Loss) After Taxes
        CAST(COALESCE(
        (((COALESCE(m.gross_profit,0)/COALESCE(m.revenues,0))-(COALESCE(m.`total_SG&A`,0)/COALESCE(m.revenues,0))) + 
        (((COALESCE(m.other_income_loss,0)/COALESCE(m.revenues,0))+(COALESCE(m.gain_loss_on_sale_of_assets,0)/COALESCE(m.revenues,0))-
        (COALESCE(m.other_expenses,0)/COALESCE(m.revenues,0))+(COALESCE(m.joint_venture_income,0)/COALESCE(m.revenues,0))-
        (COALESCE(m.interest_expense,0)/COALESCE(m.revenues,0))+(COALESCE(m.`interest_&_dividend_income`,0)/COALESCE(m.revenues,0)))+
        (COALESCE(m.income_from_discontinued_operations,0)/COALESCE(m.revenues,0)))-(COALESCE(m.provision_for_income_taxes,0)/COALESCE(m.revenues,0))) 
        ,0) AS DECIMAL(10,6)) AS `CS Net Income/(Loss) After Taxes`,
    -- Non-Controlling Interest in Net Income/(Loss)  
	CAST((COALESCE(m.non_controlling_interest,0)) AS DECIMAL(15,2)) AS `Non-Controlling Interest in Net Income/(Loss)`,
		-- CS Non-Controlling Interest in Net Income/(Loss)
		CAST(COALESCE((COALESCE(m.non_controlling_interest,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Non-Controlling Interest in Net Income/(Loss)`,
    -- Depreciation / Amortization Expense  
	CAST((COALESCE(m.`depreciation_&_amortization`,0)) AS DECIMAL(15,2)) AS `Depreciation / Amortization Expense`,
		-- CS Depreciation / Amortization Expense
        CAST(COALESCE((COALESCE(m.`depreciation_&_amortization`,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Depreciation / Amortization Expense`,
    -- EBITDA  
    CAST(COALESCE(m.ebitda,0) AS DECIMAL(15,2)) AS `EBITDA`,
		-- CS EBITDA
        CAST(COALESCE(COALESCE(m.ebitda,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `CS EBITDA`,
    -- Statement of Cash Flows  
    -- Other Adjustments to Net Income  
	CAST((COALESCE(m.other_adjustments_to_reconcile_net_income,0)) AS DECIMAL(15,2)) AS `Other Adjustments to Net Income`,
		-- CS Other Adjustments to Net Income
        CAST(COALESCE((COALESCE(m.other_adjustments_to_reconcile_net_income,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Other Adjustments to Net Income`,
	    -- Total Adjustments  
    CAST((COALESCE(m.total_adjustments,0)) AS DECIMAL(15,2)) AS `Total Adjustments`,
		-- CS Total Adjustment 
        CAST(COALESCE((COALESCE(m.total_adjustments,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Total Adjustments`,
    -- Cash Flows from Operating Activities  
    CAST((COALESCE(m.cash_flows_from_operating_activities,0)) AS DECIMAL(15,2)) AS `Cash Flows from Operating Activities`,
		-- CS Cash Flows from Operating Activities
        CAST(COALESCE((COALESCE(m.cash_flows_from_operating_activities,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Cash Flows from Operating Activities`,
    -- Cash Flows from Investing Activities  
    CAST((COALESCE(m.cash_flows_from_investing_activities,0)) AS DECIMAL(15,2)) AS `Cash Flows from Investing Activities`,
    -- CS Cash Flows from Investing Activities  
	CAST(COALESCE((COALESCE(m.cash_flows_from_investing_activities,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Cash Flows from Investing Activities`,
    -- Cash Flows from Financing Activities  
    CAST((COALESCE(m.cash_flows_from_financing_activities,0)) AS DECIMAL(15,2)) AS `Cash Flows from Financing Activities`,
		-- CS Cash Flows from Financing Activities
        CAST(COALESCE((COALESCE(m.cash_flows_from_financing_activities,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Cash Flows from Financing Activities`,
    -- Cash Inflows  
    CAST((COALESCE(m.cash_inflows,0)) AS DECIMAL(15,2)) AS `Cash Inflows`,
		-- CS Cash Inflows
        CAST(COALESCE((COALESCE(m.cash_inflows,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `CS Cash Inflows`,
    -- Cash Outflows  
    CAST((COALESCE(m.cash_outflows,0)) AS DECIMAL(15,2)) AS `Cash Outflows`,
		-- CS Cash Outflows
        CAST(COALESCE((COALESCE(m.cash_outflows,0)/COALESCE(m.revenues,0)) 
        ,0) AS DECIMAL(10,6)) AS `CS Cash Outflows`,
    -- Net Increase (Decrease) in Cash  
    CAST(COALESCE(
    (COALESCE(m.cash_flows_from_operating_activities,0)+COALESCE(m.cash_flows_from_investing_activities,0)+
	COALESCE(m.cash_flows_from_investing_activities,0)),0) AS DECIMAL(15,2)) AS `Net Increase (Decrease) in Cash`,
		-- CS Net Increase (Decrease) in Cash
		CAST(COALESCE(
		((COALESCE(m.cash_flows_from_operating_activities,0)/COALESCE(m.revenues,0))+(COALESCE(m.cash_flows_from_investing_activities,0)/COALESCE(m.revenues,0))+
		(COALESCE(m.cash_flows_from_investing_activities,0)/COALESCE(m.revenues,0))/COALESCE(m.revenues,0)),0) 
        AS DECIMAL(10,6)) AS `CS Net Increase (Decrease) in Cash`,

--     -- Financial Ratios  
--     -- Current Ratio
    CAST(COALESCE((COALESCE(m.total_current_assets,0)/COALESCE(m.total_current_liabilities,0)) ,0) AS DECIMAL (10,6)) AS `Current Ratio`,
    
    -- Quick Ratio
    CAST(COALESCE(((COALESCE(m.`cash_&_cash_equivalents`,0)+COALESCE(m.marketable_securities,0)+COALESCE(m.accounts_receivable_total,0)) / COALESCE(m.total_current_liabilities,0)) ,0) AS DECIMAL (10,6)) AS `Quick Ratio`,
    
	-- Cash Ratio
	CAST(COALESCE(((COALESCE(m.`cash_&_cash_equivalents`,0)+COALESCE(m.marketable_securities,0))/ COALESCE(m.total_current_liabilities,0)),0) AS DECIMAL(10,6)) AS `Cash Ratio`,
    
    -- Debt to Equity
    CAST(COALESCE(COALESCE(m.total_liabilities,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)),0) AS DECIMAL (10,6)) AS `Debt to Equity`,
    
    -- Return on Equity
	CAST(COALESCE(COALESCE(m.net_income_loss_before_taxes,0) / COALESCE((COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)),0),0) AS DECIMAL(10,6)) AS `Return on Equity`,
    
    -- Return on Assets
    CAST(COALESCE(COALESCE(m.net_income_loss_before_taxes,0) / COALESCE(m.total_assets,0),0) AS DECIMAL (10,6)) AS `Return on Assets`,
    
	-- Return on Capital Employed
    CAST(COALESCE(((COALESCE(m.gross_profit,0)-(COALESCE(m.`total_SG&A`,0)))/(COALESCE(m.total_assets,0)-COALESCE(m.total_current_liabilities,0))),0) AS DECIMAL (10,6)) AS `Return on Capital Employed`,
    
    -- Overbillings to Underbillings
    CAST(COALESCE((COALESCE(m.`billings_in_excess_of_costs_&_estimated_earnings`,0)/COALESCE(m.`cost_&_estimated_earnings_in_excess_of_billings`,0)) ,0) AS DECIMAL(10,6)) AS `Overbillings to Underbillings`,

	-- Operating Profit (EBIT) Margin
    CAST(COALESCE((CASE
		WHEN (COALESCE(m.ebit,0)/COALESCE(m.revenues,0))=1 THEN NULL
        ELSE (COALESCE(m.ebit,0)/COALESCE(m.revenues,0)) END)
	,0) AS DECIMAL(10,6)) AS `Operating Profit Margin`,

    -- Gross Profit Margin
    CAST(COALESCE((CASE
		WHEN (COALESCE(m.gross_profit,0)/COALESCE(m.revenues,0))=1 THEN NULL
        ELSE (COALESCE(m.gross_profit,0)/COALESCE(m.revenues,0)) END)
	,0) AS DECIMAL(10,6)) AS `Gross Profit Margin`,
    
	-- EBIT Margin
    CAST(COALESCE(COALESCE(m.ebit,0)/COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `EBIT Margin`,
    
    -- EBITDA Margin
    CAST(COALESCE(COALESCE(m.ebitda,0) / COALESCE(m.revenues,0),0) AS DECIMAL(10,6)) AS `EBITDA Margin`,
    
    -- Overhead Margin 
    CAST(COALESCE((COALESCE(m.`total_SG&A`,0)/(COALESCE(m.revenues,0))) ,0) AS DECIMAL(10,6)) AS `Overhead Margin`,
    
    -- Net Profit Margin
    CAST(COALESCE((CASE
    WHEN (((COALESCE(m.gross_profit,0) - COALESCE(m.`total_SG&A`,0)) + ((COALESCE(m.other_income_loss,0) + COALESCE(m.gain_loss_on_sale_of_assets,0)-COALESCE(m.other_expenses,0)+COALESCE(m.joint_venture_income,0)- 
    COALESCE(m.interest_expense,0) + COALESCE(m.`interest_&_dividend_income`,0)) + COALESCE(m.income_from_discontinued_operations,0))) / COALESCE(m.revenues,0))=1 THEN NULL
    ELSE (((COALESCE(m.gross_profit,0) - COALESCE(m.`total_SG&A`,0)) + ((COALESCE(m.other_income_loss,0) + COALESCE(m.gain_loss_on_sale_of_assets,0)-COALESCE(m.other_expenses,0)+COALESCE(m.joint_venture_income,0)- 
    COALESCE(m.interest_expense,0) + COALESCE(m.`interest_&_dividend_income`,0)) + COALESCE(m.income_from_discontinued_operations,0))) / COALESCE(m.revenues,0)) END)
    ,0) AS DECIMAL(10,6)) AS `Net Profit Margin`,
    
    -- Return on Working Capital
    CAST(COALESCE((
	((COALESCE(m.gross_profit,0) - COALESCE(m.`total_SG&A`,0)) + ((COALESCE(m.other_income_loss,0) + COALESCE(m.gain_loss_on_sale_of_assets,0) - COALESCE(m.other_expenses,0) + COALESCE(m.joint_venture_income,0)- 
    COALESCE(m.interest_expense,0) + COALESCE(m.`interest_&_dividend_income`,0)) + COALESCE(m.income_from_discontinued_operations,0))) / (COALESCE(m.total_current_assets,0) - COALESCE(m.total_current_liabilities,0)))
    ,0) AS DECIMAL(10,6)) AS `Return on Working Capital`,
    
    -- Return on Net Assets
    CAST(COALESCE((
    ((COALESCE(m.gross_profit,0) - COALESCE(m.`total_SG&A`,0)) + ((COALESCE(m.other_income_loss,0) + COALESCE(m.gain_loss_on_sale_of_assets,0) - COALESCE(m.other_expenses,0) + COALESCE(m.joint_venture_income,0)- 
    COALESCE(m.interest_expense,0) + COALESCE(m.`interest_&_dividend_income`,0)) + COALESCE(m.income_from_discontinued_operations,0))) / (COALESCE(m.total_fixed_assets_net,0) + 
    (COALESCE(m.total_current_assets,0) - COALESCE(m.total_current_liabilities,0))))
    ,0) AS DECIMAL(10,6)) AS `Return on Net Assets`,
    
    -- Current Assets to Total Assets
    CAST(COALESCE((
    COALESCE(m.total_current_assets,0) / COALESCE(m.total_assets,0))
    ,0) AS DECIMAL(10,6)) AS `Current Assets to Total Assets`,
    
    -- Working Capital Turnover
    CAST(COALESCE((COALESCE(m.revenues,0)/(COALESCE(m.total_current_assets,0)-COALESCE(m.total_current_liabilities,0))),0) AS DECIMAL(10,6)) AS `Working Capital Turnover`,
    
    -- Total Assets to Revenue
    CAST(COALESCE((COALESCE(m.total_assets,0)/COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `Total Assets to Revenue`,
    
    -- Days of Cash-on-Hand
    CAST(COALESCE((COALESCE(m.`cash_&_cash_equivalents`,0) / ((COALESCE(m.`total_SG&A`,0) + (COALESCE(m.interest_expense,0)))/365)),0) AS DECIMAL(10,6)) AS `Days of Cash-on-Hand`,

    -- Days of Underbillings
    CAST(COALESCE((COALESCE(m.`cost_&_estimated_earnings_in_excess_of_billings`,0) / (COALESCE(m.revenues,0)/365)),0) AS DECIMAL(10,6)) AS `Days of Underbillings`,
    
    -- Days of Overbillings
    CAST(COALESCE((COALESCE(m.`billings_in_excess_of_costs_&_estimated_earnings`,0) / (COALESCE(m.revenues,0)/365)),0) AS DECIMAL(10,6)) AS `Days of Overbillings`,
    
    -- Days of Accounts Receivable
    CAST(COALESCE((COALESCE(m.accounts_receivable_total,0) / (COALESCE(m.revenues,0)/365)),0) AS DECIMAL(10,6)) AS `Days of Accounts Receivable`,
    
    -- Days of Accounts Receivable (less Retention)
    CAST(COALESCE(((COALESCE(m.accounts_receivable_total,0) - COALESCE(m.accounts_receivable_retention,0)) / (COALESCE(m.revenues,0)/365)),0) AS DECIMAL(10,6)) AS `Days of Accounts Receivable (less Retention)`,
    
    -- Days of Accounts Payable
    CAST(COALESCE((COALESCE(m.accounts_payable_total,0) / (COALESCE(m.revenues,0)/365)),0) AS DECIMAL(10,6)) AS `Days of Accounts Payable`,
    
    -- Days of Accounts Payable (less Retention)
    CAST(COALESCE(((COALESCE(m.accounts_payable_total,0) - COALESCE(m.accounts_payable_retention,0)) / (COALESCE(m.revenues,0)/365)),0) AS DECIMAL(10,6)) AS `Days of Accounts Payable (less Retention)`,
    
    -- Fixed Assets (net) to Equity
    CAST(COALESCE(COALESCE(m.total_fixed_assets_net,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)),0) AS DECIMAL(10,6)) AS `Fixed Assets (net) to Equity`,
    
    -- Equity Multiplier
    CAST(COALESCE(COALESCE(m.total_assets,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)),0) AS DECIMAL(10,6)) AS `Equity Multiplier`,
    
    -- Current Liabilities to Equity
    CAST(COALESCE(COALESCE(m.total_current_liabilities,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)),0) AS DECIMAL(10,6)) AS `Current Liabilities to Equity`,
    
    -- Total Liabilities to Equity
    CAST(COALESCE((COALESCE(m.total_liabilities,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0))),0) AS DECIMAL(10,6)) AS `Total Liabilities to Equity`,
    
    -- Equity to Overhead
    CAST(COALESCE(((COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)) / COALESCE(m.`total_SG&A`,0)),0)  AS DECIMAL(10,6)) AS `Equity to Overhead`,
    
    -- Underbillings to Equity
    CAST(COALESCE((COALESCE(m.`cost_&_estimated_earnings_in_excess_of_billings`,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0))),0) AS DECIMAL(10,6)) AS `Underbillings to Equity`,
    
    -- Backlog to Equity
    CAST(COALESCE((COALESCE(m.total_backlog,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0))),0) AS DECIMAL(10,6)) AS `Backlog to Equity`,
    
    -- Overhead to Revenue
    CAST(COALESCE((COALESCE(m.total_operating_expenses,0) / COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `Overhead to Revenue`,
    
    -- Overhead to Direct Costs
    CAST(COALESCE((COALESCE(m.total_operating_expenses,0) / COALESCE(m.total_direct_costs,0)),0) AS DECIMAL(10,6)) AS `Overhead to Direct Costs`,
    
    -- Times Interest Earned 
    CAST(COALESCE(((COALESCE(m.gross_profit,0)-COALESCE(m.`total_SG&A`,0)) / COALESCE(m.interest_expense,0)),0) AS DECIMAL(10,6)) AS `Times Interest Earned`,
    
    -- Accounts Payable to Revenue
    CAST(COALESCE((COALESCE(m.accounts_payable_total,0) / COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `Accounts Payable to Revenue`,
    
    -- Working Capital to Revenue
	CAST(COALESCE(((COALESCE(m.total_current_assets,0) - COALESCE(m.total_current_liabilities,0)) / COALESCE(m.revenues,0)),0) AS DECIMAL(10,6)) AS `Working Capital to Revenue`,
    
    -- Asset Turnover
    CAST(COALESCE((COALESCE(m.revenues,0) / COALESCE(m.total_assets,0)),0) AS DECIMAL(10,6)) AS `Asset Turnover`,
    
    -- Equity Turnover
    CAST((COALESCE(COALESCE(m.revenues,0) / (COALESCE(m.shareholder_member_partner_equity,0)-COALESCE(m.non_controlling_interest,0)),0)) AS DECIMAL(10,6)) AS `Equity Turnover`,
    
    -- Materials & Subcontracts to Labor Ratio
    -- Adjusted for outliers  
    CAST(COALESCE((CASE 
		WHEN COALESCE((COALESCE((COALESCE(m.materials_cost,0)+COALESCE(m.subcontracts_cost,0)),0)/COALESCE(m.labor_cost,0)),0) > 2 OR
			 COALESCE((COALESCE((COALESCE(m.materials_cost,0)+COALESCE(m.subcontracts_cost,0)),0)/COALESCE(m.labor_cost,0)),0) < -2 THEN NULL
		ELSE COALESCE((COALESCE((COALESCE(m.materials_cost,0)+COALESCE(m.subcontracts_cost,0)),0)/COALESCE(m.labor_cost,0)),0)
	END),0) AS DECIMAL(10,6)) AS `Materials & Subcontract to Labor Ratio`,

    -- Degree of Fixed Asset Newness
    CAST(COALESCE((CASE
    WHEN (COALESCE(m.`property_plant_&_equipment_net`,0)/COALESCE(m.`property_plant_&_equipment_gross`,0))=1 THEN NULL
    ELSE (COALESCE(m.`property_plant_&_equipment_net`,0)/COALESCE(m.`property_plant_&_equipment_gross`,0)) END)
    ,0) AS DECIMAL(10,6)) AS `Degree of Fixed Asset Newness`,
    
    -- Backlog to Working Capital 
    CAST(COALESCE((CASE
    WHEN (COALESCE(m.total_backlog,0)/(COALESCE(m.total_current_assets,0) - COALESCE(m.total_current_liabilities,0)))=0 THEN NULL
    ELSE COALESCE((COALESCE(m.total_backlog,0)/(COALESCE(m.total_current_assets,0) - COALESCE(m.total_current_liabilities,0))),0) END),0) 
    AS DECIMAL(10,6)) AS `Backlog to Working Capital`,
    
    -- Months in Backlog
    CAST(COALESCE((CASE
	WHEN (COALESCE(m.total_backlog,0)/(COALESCE(m.revenues,0)/12))=0 THEN NULL
    ELSE COALESCE((COALESCE(m.total_backlog,0)/(COALESCE(m.revenues,0)/12)),0) END),0)
    AS DECIMAL(10,6)) AS `Months in Backlog`
     
FROM 
    SF_account a 
	INNER JOIN FSA_Main m ON m.Data_Key__c = a.Data_Key__c
	LEFT JOIN SF_peer_groups pg ON pg.`Id` = a.Peer_Group__c
    LEFT JOIN SF_peer_groups AS pg2 ON a.X2nd_Peer_Group__c = pg2.Id
    LEFT JOIN Company_Alias ca ON a.Data_Key__c = ca.Data_Key__c
	LEFT JOIN RMA_FSA_full AS c ON a.NAICSCode__c = c.`NAICS Code` AND m.`fsa_year` = c.`Year`

GROUP BY a.Data_Key__c,  m.`fsa_year`

;


