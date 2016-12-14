/* Data is pulled into Metrics QC Spredsheet*/

DECLARE @Program INT
SET @Program = 4

DECLARE @Touch Int
SET @Touch = 0

--Touch Type Definitions
--List of all current Touch Types in the Best View Tool for the specific program forreference
SELECT a.*
FROM bvt_prod.Touch_Definition_VW a
JOIN bvt_prod.Program_LU_TBL b
on a.Program_Name = b.Program_Name
WHERE idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL = @Program


--Response Rate
--Lists the number of Response Rate Records for each Start Date, can find touches that have none
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Rate_Start_Date, c.CountOfKPI  
FROM bvt_prod.Program_Touch_Definitions_TBL b 
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.KPI_Rates a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Rate_Start_Date, COUNT(KPI_Rate) AS CountOfKPI
		FROM bvt_prod.KPI_Rates 
		GROUP BY idProgram_Touch_Definitions_TBL_FK,  Rate_Start_Date) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Rate_Start_Date = c.Rate_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.Rate_Start_Date


--Response Rate Duplicates
--Checks for duplicates based on Touch Type, KPI Type and Start Date
SELECT a.*, b.Touch_Name, d.Media
FROM bvt_prod.KPI_Rates a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (  SELECT idProgram_Touch_Definitions_TBL_FK, idKPI_Types_FK, Rate_Start_Date, COUNT(KPI_Rate) AS CountOfRecords
		FROM bvt_prod.KPI_Rates 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, idKPI_Types_FK, Rate_Start_Date
		HAVING COUNT(KPI_Rate) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idKPI_Types_FK = c.idKPI_Types_FK 
		AND a.Rate_Start_Date = c.Rate_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idKPI_Types_FK, a.Rate_Start_Date


--Response Curve
--Lists the length of the Response Curves by Start Date and KPI Type
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Curve_Start_Date, c.idkpi_type_FK, CountOfWeeks
FROM bvt_prod.Program_Touch_Definitions_TBL b 
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.Response_Curve a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK,  Curve_Start_Date, idkpi_type_FK, COUNT(Week_ID) AS CountOfWeeks
		FROM bvt_prod.Response_Curve 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Curve_Start_Date = c.Curve_Start_Date
		AND a.idKPI_Type_FK = c.idkpi_type_FK
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.idkpi_type_FK, c.Curve_Start_Date


--Response Curve Duplicates
--Checks for duplicates based on Touch Type, KPI Type, Week ID and Start Date
SELECT a.*, b.Touch_Name, d.Media
FROM bvt_prod.Response_Curve a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Week_ID, Curve_Start_Date, idkpi_type_FK, COUNT(week_percent) AS CountOfRecords
		FROM bvt_prod.Response_Curve 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Week_ID, Curve_Start_Date, idkpi_type_FK
		HAVING COUNT(week_percent) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Week_ID = c.Week_ID 
		AND a.Curve_Start_Date = c.Curve_Start_Date
		AND a.idKPI_Type_FK = c.idkpi_type_FK
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.Curve_Start_Date, a.Week_ID


--Total Response Curve
--Checks that Week Percents sum to 1 based on Touch Type, KPI Type and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Response_Curve a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK, ROUND(SUM(week_percent),2) AS TotalCurve
		FROM bvt_prod.Response_Curve 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK
		HAVING  ROUND(SUM(week_percent),2) <> 1.00) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idkpi_type_FK = c.idkpi_type_FK 
		AND a.Curve_Start_Date = c.Curve_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.Curve_Start_Date


--Percent by Day
--Lists the number of records for percent by day by Start Date and KPI Type
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Daily_Start_date, c.idkpi_type_FK, CountOfDays
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_Prod.Response_Daily a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Daily_Start_date, idkpi_type_FK, COUNT(Day_of_Week) AS CountOfDays
		FROM bvt_prod.Response_Daily 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Daily_Start_date, idkpi_type_FK) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Daily_Start_date = c.Daily_Start_date
		AND a.idkpi_type_FK = c.idkpi_type_FK
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.idkpi_type_FK, c.Daily_Start_date


--Percent by Day Duplicates
--Checks for duplicates based on Touch Type, KPI Type, Day of Week and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_Prod.Response_Daily a
JOIN bvt_prod.Program_Touch_Definitions_TBL b 
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Day_of_Week, Daily_Start_date, idkpi_type_FK, COUNT(Day_Percent) AS CountOfRecords
		FROM bvt_prod.Response_Daily 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Day_of_Week, Daily_Start_date, idkpi_type_FK
		HAVING  COUNT(Day_percent) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Day_of_Week = c.Day_of_Week 
		AND a.Daily_Start_date = c.Daily_Start_date
		AND a.idkpi_type_FK = c.idkpi_type_FK
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE  b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.Daily_Start_date, a.Day_of_Week


--Total Percent by Day
--Checks that Day Percents sum to 1 based on Touch Type, KPI Type and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Response_Daily a
JOIN bvt_Prod.Program_Touch_Definitions_TBL b 
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Daily_Start_date, idkpi_type_FK, ROUND(SUM(Day_Percent),2) as TotalCurve
		FROM bvt_prod.Response_Daily 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Daily_Start_date, idkpi_type_FK
		HAVING  ROUND(SUM(Day_Percent),2) <> 1.00 AND ROUND(SUM(Day_Percent),2) <> 7.00) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Daily_Start_date = c.Daily_Start_date 
		AND a.idkpi_type_FK = c.idkpi_type_FK
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.Daily_Start_date, a.Day_of_Week


--Sales Rate
--Lists the number of Product Sales Rate Records for each Start Date
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Sales_Rate_Start_Date, c.idkpi_type_FK, CountOfProducts
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.Sales_Rates a 
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Sales_Rate_Start_Date, idkpi_type_FK, COUNT(idProduct_LU_TBL_FK) as CountOfProducts
		FROM bvt_prod.Sales_Rates 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Sales_Rate_Start_Date, idkpi_type_FK) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idkpi_type_FK = c.idkpi_type_FK 
		AND a.Sales_Rate_Start_Date = c.Sales_Rate_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.idkpi_type_FK, c.Sales_Rate_Start_Date


--Sales Rate Duplicates
--Checks for duplicates based on Touch Type, KPI Type, Product Code and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Sales_Rates a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, idProduct_LU_TBL_FK, Sales_Rate_Start_Date, idkpi_type_FK, COUNT(Sales_Rate) as CountOfRecords
		FROM bvt_prod.Sales_Rates 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, idProduct_LU_TBL_FK, Sales_Rate_Start_Date, idkpi_type_FK
		HAVING COUNT(Sales_Rate) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idkpi_type_FK = c.idkpi_type_FK 
		AND a.idProduct_LU_TBL_FK = c.idProduct_LU_TBL_FK
		AND a.Sales_Rate_Start_Date = c.Sales_Rate_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.idProduct_LU_TBL_FK, a.Sales_Rate_Start_Date


--Sales Curve
--Lists the length of the Sales Curves by Start Date and KPI Type
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Curve_Start_Date, c.idkpi_type_FK, CountOfWeeks
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.Sales_Curve a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK, COUNT(Week_ID) as CountOfWeeks
		FROM bvt_prod.Sales_Curve 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idkpi_type_FK = c.idkpi_type_FK 
		AND a.Curve_Start_Date = c.Curve_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.idkpi_type_FK, c.Curve_Start_Date


--Sales Curve Duplicates
--Checks for duplicates based on Touch Type, KPI Type, Week ID and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Sales_Curve a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK, ROUND(SUM(week_percent),2) as TotalCurve
		FROM bvt_prod.Sales_Curve 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Curve_Start_Date, idkpi_type_FK
		HAVING ROUND(SUM(week_percent),2) <> 1.00) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
	AND a.idkpi_type_FK = c.idkpi_type_FK 
	AND a.Curve_Start_Date = c.Curve_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.Curve_Start_Date, a.Week_ID


--Total Sales Curves
--Checks that Week Percents sum to 1 based on Touch Type, KPI Type and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Sales_Curve a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Week_ID, Curve_Start_Date, idkpi_type_FK, COUNT(Week_Percent) as CountOfRecords
		FROM bvt_prod.Sales_Curve 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Week_ID, Curve_Start_Date, idkpi_type_FK
		HAVING COUNT(week_percent) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idkpi_type_FK = c.idkpi_type_FK 
		AND a.Curve_Start_Date = c.Curve_Start_Date
		AND a.Week_ID = c.Week_ID
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idkpi_type_FK, a.Curve_Start_Date, a.Week_ID


--CPP Categories
--Lists the number of CPP Categories and Bill Timing combinations by Start Date
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.CPP_Start_Date, CountOfCategories
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.CPP a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK,  CPP_Start_Date, COUNT(idCPP) as CountOfCategories
		FROM bvt_prod.CPP 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, CPP_Start_Date) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.CPP_Start_Date = c.CPP_Start_Date 
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.CPP_Start_Date


--CPP Duplicates
--Checks for duplicates based on Touch Type, CPP Category, Bill Timing and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.CPP a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, idCPP_Category_FK, CPP_Start_Date, Bill_Timing, COUNT(CPP) as CountOfRecords
		FROM bvt_prod.CPP 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, idCPP_Category_FK, CPP_Start_Date, Bill_Timing
		HAVING COUNT(CPP) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idCPP_Category_FK = c.idCPP_Category_FK
		AND a.CPP_Start_Date = c.CPP_Start_Date 
		AND a.Bill_Timing = c.Bill_Timing
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.idCPP_Category_FK, a.CPP_Start_Date, a.Bill_Timing


--Seasonality Adjustment
--Lists the number of Seasonality Records by Media Year
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, q.Media_Year, CountOfRecords
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT COALESCE(z.idProgram_touch_definitions_TBL_FK, e.idProgram_Touch_Definitions_TBL_FK) AS idProgram_Touch_Definitions_TBL_FK,
Media_Year FROM 
	((SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
FULL JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK, DATEPART(YYYY, InHome_Date) as Media_Year
			FROM bvt_prod.Flight_Plan_Records) e
ON z.idProgram_Touch_Definitions_TBL_FK = e.idProgram_Touch_Definitions_TBL_FK)) q
ON b.idProgram_Touch_Definitions_TBL = q.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Media_Year, COUNT(Seasonality_Adj) as CountOfRecords
		FROM bvt_prod.Seasonality_Adjustements
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Media_Year) c
	ON q.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND q.Media_Year = c.Media_Year 
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, q.Media_Year


--Seasonality Adjustment Duplicates
--Checks for duplicates based on Touch Type, Media Year, Media Month and Media Week
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Seasonality_Adjustements a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Media_Year, Media_Month, Media_Week, COUNT(Seasonality_Adj) as CountOfRecords
		FROM bvt_prod.Seasonality_Adjustements 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Media_Year, Media_Month, Media_Week
		HAVING COUNT(Seasonality_Adj) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Media_Year = c.Media_Year 
		AND a.Media_Month = c.Media_Month
		AND a.Media_Week = c.Media_Week
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.Media_Year, a.Media_Month, a.Media_Week


--Total Seasonality
--Checks that seasonality adjustments sum to 52 based on Touch Type and Media Year
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Seasonality_Adjustements a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Media_Year, ROUND(SUM(Seasonality_Adj),2) as TotalSeasonality
		FROM bvt_prod.Seasonality_Adjustements 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Media_Year
		HAVING ROUND(SUM(Seasonality_adj),2) <> CASE WHEN Media_Year = 2017 THEN 53.00 ELSE 52.00 END) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
			AND a.Media_Year = c.Media_Year
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.Media_Year, a.Media_Month, a.Media_Week


--Target Rate Adjustment
--Lists the number of Target Rate Adjustment Records by Start Date
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Adj_Start_Date, CountOfRecords
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.Target_Rate_Adjustments a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Adj_Start_Date,COUNT(idTarget_Rate_Adjustments) as CountOfRecords
		FROM bvt_prod.Target_Rate_Adjustments
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Adj_Start_Date) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Adj_Start_Date = c.Adj_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.Adj_Start_Date


--Target Rate Duplicates
--Checks for duplicates based on Touch Type, Adjustment Reason and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Target_Rate_Adjustments a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Adj_Start_Date, idTarget_Rate_Reasons_LU_TBL_FK, COUNT(idTarget_Rate_Reasons_LU_TBL_FK) as CountOfRecords
		FROM bvt_prod.Target_Rate_Adjustments
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Adj_Start_Date, idTarget_Rate_Reasons_LU_TBL_FK
		HAVING COUNT(idTarget_Rate_Reasons_LU_TBL_FK) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.idTarget_Rate_Reasons_LU_TBL_FK = c.idTarget_Rate_Reasons_LU_TBL_FK
		AND a.Adj_Start_Date = c.Adj_Start_Date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.Adj_Start_Date, a.idTarget_Rate_Reasons_LU_TBL_FK


--Drop Date Calculation
--Lists the number of Drop Date Calculations by Start Date
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.drop_start_date, CountOfRecords 
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.Drop_Date_Calc_Rules a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, drop_start_date, COUNT(Days_Before_Inhome) as CountOfRecords
		FROM bvt_prod.Drop_Date_Calc_Rules 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, drop_start_date) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.drop_start_date = c.drop_start_date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.drop_start_date


--Drop Date Calc duplicates
--Checks for duplicates based on Touch Type and Start Date
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Drop_Date_Calc_Rules a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, drop_start_date, COUNT(Days_Before_Inhome) AS CountOfRecords
		FROM bvt_prod.Drop_Date_Calc_Rules 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, drop_start_date
		HAVING COUNT(Days_Before_Inhome) > 1) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.drop_start_date = c.drop_start_date
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.drop_start_date
