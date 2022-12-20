
-- Cleaning Data
-- Total Data Rows 541909

SELECT * FROM Online_Retail


-- Customer Id > 0/not null
-- Total 406829
-- Customer Id = 0/null
-- 135080

WITH online_retail_first AS
(
	SELECT 
		InvoiceNo
		, StockCode
		, Description
		, Quantity
		, InvoiceDate
		, UnitPrice
		, CustomerID
		, Country
	FROM
		Online_Retail
	WHERE
		CustomerID is not null 
)
, online_retail_second AS
	-- Quantity > 0/ and UnitPrice > 0/
	-- Total Data Rows 397884
(
	SELECT 
	*
	FROM 
		online_retail_first
	WHERE
		Quantity > 0 and UnitPrice > 0
)
, online_retail_third AS
	-- Check for Duplicate Data
	-- Total Rows 392669
	-- Total Duplicated Rows 5215
(
	SELECT 
		*, ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode, Quantity ORDER BY InvoiceDate) data_dup
	FROM
		online_retail_second
)
SELECT
	*
INTO
	#online_retail_main			-- Create Local Temp Table for Final Data
FROM 
	online_retail_third
WHERE
	data_dup = 1


-- Clean Data
-- COHORT ANALYSIS
SELECT * FROM #online_retail_main

-- Set Unique Identifier = CustomerId
-- Initial Start Date = FirstInvoiceDate
-- Revenue Data

SELECT
	CustomerID
	, min(InvoiceDate) AS First_purchase_date
	, DATEFROMPARTS(YEAR(min(InvoiceDate)),MONTH(min(InvoiceDate)),1) AS Cohort_date
INTO
	#cohort
FROM
	#online_retail_main
GROUP BY
	CustomerID

-- Cohort Table
SELECT * FROM #cohort



-- Cohort Index
SELECT
	mc_diff.*
	, cohort_index = year_diff * 12 + month_diff + 1
INTO
	#cohort_retention
FROM
(
	SELECT
		mc.*
		, year_diff = invoice_year - cohort_year
		, month_diff = invoice_month - cohort_month
	FROM
	(
		SELECT
			m.*
			, c.Cohort_date
			, YEAR(m.InvoiceDate) invoice_year
			, MONTH(m.InvoiceDate) invoice_month
			, YEAR(c.cohort_date) cohort_year
			, MONTH(c.cohort_date) cohort_month
		FROM 
			#online_retail_main m
		LEFT JOIN
			#cohort c
		ON
			m.CustomerID = c.CustomerID
		) mc
) mc_diff
-- WHERE
-- 		CustomerID=18102

SELECT * FROM #cohort_retention


-- Pivot Data to see the cohort table
SELECT
	*
FROM
	(
	SELECT DISTINCT
		CustomerID
		, cohort_date
		, cohort_index
	FROM 
		#cohort_retention
	)cohort_table
	PIVOT(
		COUNT(CustomerID)
		FOR cohort_index IN
			(
			[1],
			[2],
			[3],
			[4],
			[5],
			[6],
			[7],
			[8],
			[9],
			[10],
			[11],
			[12],
			[13])
		) AS pivot_table
ORDER BY
	Cohort_date




SELECT DISTINCT
	cohort_index
FROM 
	#cohort_retention
order by 1