
--Insert from bvt_prod.[Program]_Best_View_Forecast_VW into bvt_processed.Commitment_Views Table

INSERT INTO bvt_processed.Commitment_Views (id_Flight_Plan_Records_FK, idProgram_Touch_Definitions_TBL_FK,
Campaign_Name, InHome_Date, Media_Year, Media_Month, Media_Week, KPI_TYPE, Product_Code, Forecast_DayDate, Forecast, CV_Submission, Extract_Date)
SELECT a.idFlight_Plan_Records, idProgram_Touch_Definitions_TBL, Campaign_Name, InHome_Date, Media_Year, Media_Month, Media_Week,
 KPI_Type, Product_Code, a.InHome_Date as forecast_DayDate, Forecast, 'VALB 2016 Submission 20160210', '2016-02-10'
FROM bvt_cv.VALB_Best_View_CV_20160210 a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
ON a.Touch_Name = b.Touch_Name
WHERE Media_Year = 2016



--Insert from bvt_prod.[Program]_Financial_Budget_VW into bvt_processed.Commitment_Views_Finacial Table

INSERT INTO bvt_processed.Commitment_Views_Financial (idFlight_Plan_Records_FK, idProgram_Touch_Definitions_TBL_FK, 
Campaign_Name,InHome_Date, idCPP_Category_FK, bill_month, bill_year, budget, CV_Submission, Extract_Date)
SELECT idFlight_Plan_Records, idProgram_Touch_Definitions_TBL, Campaign_Name, InHome_Date, 
idCPP_Category_FK, bill_month, bill_year, budget, 'UCLM Ret 2016 Submission 20160202', '2016-02-02'
FROM bvt_cv.UCLM_Ret_Financial_Budget_CV_20160202 a
JOIN bvt_prod.Program_Touch_Definitions_TBL b
ON a.Touch_Name = b.Touch_Name
WHERE bill_year = 2016 and budget is not null