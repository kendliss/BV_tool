
USE UVAQ

--Delete data from existinting scenario tables.

IF Object_ID('bvt_scenario.Scenario_Touch_ID') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Scenario_Touch_ID

IF Object_ID('bvt_scenario.Flight_Plan_Record_Budgets') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Flight_Plan_Record_Budgets

IF Object_ID('bvt_scenario.Flight_Plan_Records_Volume') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Flight_Plan_Records_Volume

IF Object_ID('bvt_scenario.CPP') IS NOT NULL
TRUNCATE TABLE bvt_scenario.CPP

IF Object_ID('bvt_scenario.Drop_Date_Calc_Rules') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Drop_Date_Calc_Rules

IF Object_ID('bvt_scenario.KPI_Rates') IS NOT NULL
TRUNCATE TABLE bvt_scenario.KPI_Rates

IF Object_ID('bvt_scenario.Response_Curve') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Response_Curve

IF Object_ID('bvt_scenario.Response_Daily') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Response_Daily

IF Object_ID('bvt_scenario.Sales_Curve') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Sales_Curve

IF Object_ID('bvt_scenario.Sales_Rates') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Sales_Rates

IF Object_ID('bvt_scenario.Seasonality_Adjustements') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Seasonality_Adjustements

IF Object_ID('bvt_scenario.Target_Rate_Adjustments') IS NOT NULL
TRUNCATE TABLE bvt_scenario.Target_Rate_Adjustments

IF Object_ID('bvt_scenario.External_ID_linkage_TBL_has_Flight_Plan_Records') IS NOT NULL
TRUNCATE TABLE bvt_scenario.External_ID_linkage_TBL_has_Flight_Plan_Records

IF Object_ID('bvt_scenario.External_ID_linkage_TBL') IS NOT NULL
Delete bvt_scenario.External_ID_linkage_TBL

IF Object_ID('bvt_scenario.Flight_Plan_Records') IS NOT NULL
Delete bvt_scenario.Flight_Plan_Records

IF Object_ID('bvt_scenario.Program_Touch_Definitions_TBL') IS NOT NULL
Delete bvt_scenario.Program_Touch_Definitions_TBL

--Copies data for specified touches into scenario tables from current live data

INSERT INTO bvt_scenario.Scenario_Touch_ID
--Values (168),(178)
Select idProgram_Touch_Definitions_TBL
from bvt_prod.Touch_Definition_VW
where Program_Name = 'X-Sell'

INSERT INTO bvt_scenario.Program_Touch_Definitions_TBL
SELECT * FROM bvt_prod.Program_Touch_Definitions_TBL
WHERE idProgram_Touch_Definitions_TBL in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Flight_Plan_Records (idFlight_Plan_Records, idVolume_Type_LU_TBL_FK, idProgram_Touch_Definitions_TBL_FK, Budget_Type_LU_TBL_idBudget_Type_LU_TBL,
Campaign_Name, InHome_Date, TFN_ind, URL_ind, idTarget_Rate_Reasons_LU_TBL_FK)
SELECT * FROM bvt_prod.Flight_Plan_Records
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Flight_Plan_Record_Budgets 
SELECT a.* FROM bvt_prod.Flight_Plan_Record_Budgets a
JOIN bvt_prod.Flight_Plan_Records b
on a.idFlight_Plan_Records_FK = b.idFlight_Plan_Records
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Flight_Plan_Records_Volume
SELECT a.* FROM bvt_prod.Flight_Plan_Records_Volume a
JOIN bvt_prod.Flight_Plan_Records b
on a.idFlight_Plan_Records_FK = b.idFlight_Plan_Records
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.CPP
SELECT * FROM bvt_prod.CPP 
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Drop_Date_Calc_Rules
SELECT * FROM bvt_prod.Drop_Date_Calc_Rules
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.KPI_Rates
SELECT * FROM bvt_prod.KPI_Rates 
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Response_Curve
SELECT * FROM bvt_prod.Response_Curve
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Response_Daily
SELECT * FROM bvt_prod.Response_Daily 
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Sales_Rates
SELECT * FROM bvt_prod.Sales_Rates 
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Sales_Curve
SELECT * FROM bvt_prod.Sales_Curve
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Seasonality_Adjustements
SELECT * FROM bvt_prod.Seasonality_Adjustements
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.Target_Rate_Adjustments
SELECT * FROM bvt_prod.Target_Rate_Adjustments
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.External_ID_linkage_TBL
SELECT a.* FROM bvt_prod.External_ID_linkage_TBL a
JOIN bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
ON a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
JOIN bvt_prod.Flight_Plan_Records c
on b.idFlight_Plan_Records_FK = c.idFlight_Plan_Records
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)

INSERT INTO bvt_scenario.External_ID_linkage_TBL_has_Flight_Plan_Records
SELECT b.* FROM bvt_prod.External_ID_linkage_TBL a
JOIN bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
ON a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
JOIN bvt_prod.Flight_Plan_Records c
on b.idFlight_Plan_Records_FK = c.idFlight_Plan_Records
WHERE idProgram_Touch_Definitions_TBL_FK in (Select idProgram_Touch_Definitions_TBL_FK from bvt_scenario.Scenario_Touch_ID)



