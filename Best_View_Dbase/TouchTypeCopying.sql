/* Must have new touch added into database before can run this becuase you must have the idProgram_Touch_Definitions

If anything is not copied exactly, you can comment that out and either bulk load or manually enter

*/


--  Commit Tran

Declare @A Int 
SET @A =  44 --touch that is being cloned

Declare @B Int 
Set @B = 735 --new touch


declare @C float
Set @C = 1 --factor that rates are multiplied by for response and sales rates

declare @D date
Set @D = '1/3/13'

BEGIN TRAN


--Response Rates
Insert INTO bvt_prod.KPI_Rates
select  @B as idProgram_Touch_definitions_TBL_FK,
a.idKPI_Types_FK, (KPI_Rate*@C) as KPI_Rate, @D as Rate_Start_Date 
from bvt_prod.KPI_Rates a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Rate_Start_Date) as startdate, idkpi_types_FK
		from bvt_prod.KPI_Rates
		group by idProgram_Touch_Definitions_TBL_FK, idkpi_types_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Rate_Start_Date = b.startdate and a.idkpi_types_FK = b.idkpi_types_FK
where a.idProgram_Touch_Definitions_TBL_FK = @a



--Response Curve

INSERT INTO bvt_prod.Response_Curve
select @B as idProgram_Touch_Definitions_TBL_FK, a.Week_ID, @D as Curve_Start_Date,
a.idkpi_type_FK, a.week_percent  
from bvt_prod.Response_Curve a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Curve_Start_Date) as startdate, idkpi_type_FK
		from bvt_prod.Response_Curve
		group by idProgram_Touch_Definitions_TBL_FK, idkpi_type_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Curve_Start_Date = b.startdate and a.idkpi_type_FK = b.idkpi_type_FK
where a.idProgram_Touch_Definitions_TBL_FK =@A 
order by idkpi_type_FK, Week_ID



--sales rates

Insert into bvt_prod.Sales_Rates
select idProduct_LU_TBL_FK, @B as idProgram_Touch_Definitions_TBL_FK, 
a.Sales_Rate_Start_Date, (Sales_Rate*@C) as Sales_Rate, a.idkpi_type_FK
from bvt_prod.Sales_Rates a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Sales_Rate_Start_Date) as startdate, idkpi_type_FK
		from bvt_prod.Sales_Rates
		group by idProgram_Touch_Definitions_TBL_FK, idkpi_type_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Sales_Rate_Start_Date = b.startdate and a.idkpi_type_FK = b.idkpi_type_FK
where a.idProgram_Touch_Definitions_TBL_FK =@A
order by idkpi_type_FK, idProduct_LU_TBL_FK



--Sales Curve

Insert INTO bvt_prod.Sales_Curve
select @B as idProgram_Touch_Definitions_TBL_FK, a.Week_ID, @D as Curve_Start_Date,
a.idkpi_type_FK, a.week_percent  
from bvt_prod.Sales_Curve a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Curve_Start_Date) as startdate, idkpi_type_FK
		from bvt_prod.Sales_Curve
		group by idProgram_Touch_Definitions_TBL_FK, idkpi_type_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Curve_Start_Date = b.startdate and a.idkpi_type_FK = b.idkpi_type_FK
where a.idProgram_Touch_Definitions_TBL_FK =@A 
order by idkpi_type_FK, Week_ID

--Daily Curves
INSERT INTO bvt_prod.Response_Daily
select @B as idProgram_Touch_Definitions_TBL_FK, a.Day_of_week, @D as Daily_Start_Date,
a.idkpi_type_FK, a.Day_percent  
from bvt_prod.Response_Daily a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Daily_Start_Date) as startdate, idkpi_type_FK
		from bvt_prod.Response_Daily
		group by idProgram_Touch_Definitions_TBL_FK, idkpi_type_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Daily_Start_Date = b.startdate and a.idkpi_type_FK = b.idkpi_type_FK
where a.idProgram_Touch_Definitions_TBL_FK =@A 
order by idkpi_type_FK, Day_of_Week


--CPP

INSERT INTO bvt_prod.CPP
select a.idCPP_Category_FK, @B as idProgram_Touch_Definitions_TBL_FK, a.CPP, a.Minimum_Volume, a.Maximum_Volume,
@D as CPP_Start_Date, a.Bill_Timing  
from bvt_prod.CPP a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(CPP_Start_Date) as startdate, idCPP_Category_FK
		from bvt_prod.CPP
		group by idProgram_Touch_Definitions_TBL_FK, idCPP_Category_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.CPP_Start_Date = b.startdate and a.idCPP_Category_FK = b.idCPP_Category_FK
where a.idProgram_Touch_Definitions_TBL_FK =@A 
order by idCPP_Category_FK


-- Seasonality

INSERT INTO bvt_prod.Seasonality_Adjustements 
select  @B as idProgram_Touch_Definitions_TBL_FK, Media_Year, Media_Month, Media_Week, Seasonality_Adj  
from bvt_prod.Seasonality_Adjustements 
where idProgram_Touch_Definitions_TBL_FK =@A 


--Target and Rate
INSERT INTO bvt_prod.Target_Rate_Adjustments
select a.idTarget_Rate_Reasons_LU_TBL_FK, @B as idProgram_Touch_Definitions_TBL_FK, a.Rate_Adjustment_Factor,
a.Adj_Start_Date, a.Volume_Adjustment
from bvt_prod.Target_Rate_Adjustments a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Adj_Start_Date) as startdate, idTarget_Rate_Reasons_LU_TBL_FK
		from bvt_prod.Target_Rate_Adjustments
		group by idProgram_Touch_Definitions_TBL_FK, idTarget_Rate_Reasons_LU_TBL_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Adj_Start_Date = b.startdate and a.idTarget_Rate_Reasons_LU_TBL_FK = b.idTarget_Rate_Reasons_LU_TBL_FK
where a.idProgram_Touch_Definitions_TBL_FK =@A 


--Drop Date

INSERT INTO bvt_prod.Drop_Date_Calc_Rules
select  @B as idProgram_Touch_Definitions_TBL_FK, Days_Before_Inhome, drop_start_date
from bvt_prod.Drop_Date_Calc_Rules a
JOIN (Select idProgram_Touch_Definitions_TBL_FK, MAX(Drop_Start_Date) as startdate
		from bvt_prod.Drop_Date_Calc_Rules
		group by idProgram_Touch_Definitions_TBL_FK) b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL_FK and 
a.Drop_Start_Date = b.startdate
where a.idProgram_Touch_Definitions_TBL_FK =@A 
