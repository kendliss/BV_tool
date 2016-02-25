
/*Used to populate the New Touch QC Spreadsheet*/

DECLARE @Touch INT
SET @Touch = 0

DECLARE @Program Int
Set @Program = 1

--Touch Type Definitions
SELECT *
FROM bvt_prod.Touch_Definition_VW 
WHERE idProgram_Touch_Definitions_TBL = @Touch

--Response Rates
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

--Response Curve
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

--Daily Curve
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

--Sales Rates
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

--Sales Curve
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

--CPP Categories
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

--Seasonality Adjustment
SELECT DISTINCT b.idProgram_Touch_Definitions_TBL, b.Touch_Name, d.Media, c.Media_Year, CountOfRecords
FROM bvt_prod.Program_Touch_Definitions_TBL b
JOIN (SELECT DISTINCT idProgram_Touch_Definitions_TBL_FK
		FROM bvt_prod.Flight_Plan_Records a
		JOIN bvt_prod.Flight_Plan_Records_Volume b
			ON a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		WHERE Volume IS NOT NULL AND Volume <> 0) z
	ON b.idProgram_Touch_Definitions_TBL = z.idProgram_Touch_Definitions_TBL_FK
LEFT JOIN bvt_prod.Seasonality_Adjustements a
	ON a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
LEFT JOIN (	SELECT idProgram_Touch_Definitions_TBL_FK, Media_Year, COUNT(Seasonality_Adj) as CountOfRecords
		FROM bvt_prod.Seasonality_Adjustements 
		GROUP BY idProgram_Touch_Definitions_TBL_FK, Media_Year) c
	ON a.idProgram_Touch_Definitions_TBL_FK = c.idProgram_Touch_Definitions_TBL_FK 
		AND a.Media_Year = c.Media_Year 
JOIN bvt_prod.Media_LU_TBL d
	ON b.idMedia_LU_TBL_FK = d.idMedia_LU_TBL
WHERE b.idProgram_Touch_Definitions_TBL = @Touch
OR b.idProgram_LU_TBL_FK = @Program
ORDER BY d.Media, b.idProgram_Touch_Definitions_TBL, c.Media_Year

--Target Rate Adjustment
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

--Drop Date Calculation
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
