/* Data is pulled into Metrics QC Spredsheet*/

DECLARE @Program INT
SET @Program = 3

DECLARE @Touch Int
SET @Touch = 0

--New Touch Definitions
SELECT *
FROM bvt_prod.Touch_Definition_VW
WHERE idProgram_Touch_Definitions_TBL = @Touch

--Response Rates
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

--Response Curves
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

--Daily Curve
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

--Total Daily Curve
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

--Sales Rates
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

--Sales Curves
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

--CPP
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
SELECT a.*, b.Touch_Name, d.Media 
FROM bvt_prod.Seasonality_Adjustements a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Media_Year, ROUND(SUM(Seasonality_Adj),2) as TotalSeasonality
		FROM bvt_prod.Seasonality_Adjustements 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Media_Year
		HAVING ROUND(SUM(Seasonality_Adj),2) <> 52.00) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
			AND a.Media_Year = c.Media_Year
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_LU_TBL_FK = @Program
OR idProgram_Touch_Definitions_TBL = @Touch
ORDER BY d.Media, a.idProgram_Touch_Definitions_TBL_FK, a.Media_Year, a.Media_Month, a.Media_Week

--Target Rate
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

--Drop Date Calc
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
