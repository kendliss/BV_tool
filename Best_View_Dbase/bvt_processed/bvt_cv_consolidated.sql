select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Media_YYYYWW], [Calendar_Year], [Calendar_Month], [idProgram_Touch_Definitions_TBL_FK], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Owner_type_matrix_id_FK], [KPI_Type], [Product_Code], [Forecast_DayDate], [Forecast], SourceTable, CV_year

into bvt_cv.CV_Combined
from

(select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Media_YYYYWW], [Calendar_Year], [Calendar_Month], [idProgram_Touch_Definitions_TBL_FK], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Owner_type_matrix_id_FK], [KPI_Type], [Product_Code], [Forecast_DayDate], [Forecast], 'ACQ_Best_View_CV_20170221' as SourceTable, 2017 as CV_year
from [bvt_cv].[ACQ_Best_View_CV_20170221]

union
select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Media_YYYYWW], [Calendar_Year], [Calendar_Month], [idProgram_Touch_Definitions_TBL_FK], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Owner_type_matrix_id_FK], [KPI_Type], [Product_Code], [Forecast_DayDate], [Forecast], 'BM_CV_DailyBlend_20170310_20170314' as SourceTable, 2017 as CV_year
from [bvt_cv].[BM_CV_DailyBlend_20170310_20170314]

union
select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Media_YYYYWW], [Calendar_Year], [Calendar_Month], [idProgram_Touch_Definitions_TBL_FK], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Owner_type_matrix_id_FK], [KPI_Type], [Product_Code], [Forecast_DayDate], [Forecast], 'Email_Best_View_CV_DS_Adj_20170227' as SourceTable, 2017 as CV_year
from [bvt_cv].[Email_Best_View_CV_DS_Adj_20170227]

union
select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Media_YYYYWW], [Calendar_Year], [Calendar_Month], [idProgram_Touch_Definitions_TBL_FK], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Owner_type_matrix_id_FK], [KPI_Type], [Product_Code], [Forecast_DayDate], [Forecast], 'Movers_AltMed_Best_View_CV_20170124' as SourceTable, 2017 as CV_year
from [bvt_cv].[Movers_AltMed_Best_View_CV_20170124]

union
select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Media_YYYYWW], [Calendar_Year], [Calendar_Month], [idProgram_Touch_Definitions_TBL_FK], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Owner_type_matrix_id_FK], [KPI_Type], [Product_Code], [Forecast_DayDate], [Forecast], 'XSell_Best_View_CV_DS_Adj_20170227' as SourceTable, 2017 as CV_year
from [bvt_cv].[XSell_Best_View_CV_DS_Adj_20170227]) as a;

create clustered index idx_c_cv_flightplanid on bvt_cv.CV_Combined(idFlight_Plan_Records);
create index idx_nc_cv_multi on bvt_cv.CV_Combined(idFlight_Plan_Records, [idProgram_Touch_Definitions_TBL_FK], Forecast_DayDate, Calendar_Year, Calendar_Month)