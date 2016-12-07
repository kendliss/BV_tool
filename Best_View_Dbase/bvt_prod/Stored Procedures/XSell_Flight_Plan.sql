DROP Proc bvt_Prod.XSell_Flight_Plan
GO

CREATE proc [bvt_prod].[XSell_Flight_Plan]

as begin

select
 b.idFlight_Plan_Records
,a.owner_type_matrix_id_FK
,a.idProgram_Touch_Definitions_TBL
,Adjustment_Reason
,Volume_Type
,Budget_Calculation
,Program_Name as 'Program'
,d.Agency
,Scorecard_program_Channel as 'Scorecard Program Channel'
,Scorecard_group as 'Scorecard Group'
,a.Touch_Name as 'Touch Name'
,Campaign_Name as 'Campaign Name'
,Media
,Audience
,ISNULL(SUM(Total_Universe_Volume),0) as 'Total Universe Volume'
,ISNULL(SUM(Total_Mailable_Volume),0) as 'Total Mailable Volume'
,Campaign_Type as 'Category'
,Tactic as 'Sub_Category'
,InHome_Date as 'Start Date'
,CASE WHEN Media = 'DM' then DATEADD(D,10,CAST(InHome_Date AS DATE))
 else InHome_Date end as 'In_Home_Date'
,ISNULL(SUM(volume),0) as 'Volume Mailed/Planed (budgeted)'
,CASE WHEN Volume_Status = 'Actual' AND InHome_Date >= GETDATE() then 'Estimate'
 else Volume_Status end as 'Volume Type'
,Channel as 'Call Strategy'
,Strategy_Eligibility as 'Strategy Eligibility'
,Lead_Offer as 'Lead Offer'
,Offer_Test_1 as 'Key Offer Testing (1)'
,Offer_Test_2 as 'Key Offer Testing (2)'
,case when TFN_ind = '1' then 'Yes'
 else 'No' end as 'TFN_ Y/N'
,case when URL_ind = '1' then 'Yes'
 else 'No' end as 'URL Y/N'
,CASE WHEN Media = 'DM' then DATEADD(D,-50,CAST(InHome_Date AS DATE))
 else DATEADD(D,-60,CAST(InHome_Date AS DATE))
 end as 'Brand New Offer Deadline'
,CASE WHEN Media = 'DM' then DATEADD(D,-57,CAST(InHome_Date AS DATE))
 else DATEADD(D,-67,CAST(InHome_Date AS DATE))
 end as 'Price Point Change Deadline'
,Media_Calendar_Daily.Date_Year as 'Year'
,Media_Calendar_Daily.Date_Month as 'Month'


from bvt_prod.Flight_Plan_Records as b

left join bvt_prod.Volume_Type_LU_TBL
on idVolume_Type_LU_TBL_FK=idVolume_Type_LU_TBL

left join bvt_prod.Program_Touch_Definitions_TBL
on idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL

left join bvt_prod.Budget_Type_LU_TBL
on Budget_Type_LU_TBL_idBudget_Type_LU_TBL=idBudget_Type_LU_TBL

left join bvt_prod.Target_Rate_Reasons_LU_TBL
on idTarget_Rate_Reasons_LU_TBL_FK=idTarget_Rate_Reasons_LU_TBL

left join bvt_prod.Lead_Offer_LU_TBL
on Lead_Offer_LU_TBL_FK=idLead_Offer_LU_TBL

left join bvt_prod.Strategy_Eligibility_LU_TBL
on Strategy_Eligibility_LU_TBL_FK=idStrategy_Eligibility_LU_TBL

left join bvt_prod.Offer_Test_1_LU_TBL
on Offer_Test_1_LU_TBL_FK=idOffer_Test_1_LU_TBL

left join bvt_prod.Offer_Test_2_LU_TBL
on Offer_Test_2_LU_TBL_FK=idOffer_Test_2_LU_TBL

left join bvt_prod.Flight_Plan_Records_Volume
on b.idFlight_Plan_Records=idFlight_Plan_Records_FK

left join bvt_prod.Touch_Definition_VW as a
on idProgram_Touch_Definitions_TBL_FK=a.idProgram_Touch_Definitions_TBL 

left join Dim.Media_Calendar_Daily
on InHome_Date=Media_Calendar_Daily.Date

left join bvt_prod.Universe_Mailable_Volumes as c
on b.idFlight_Plan_Records=c.idFlight_Plan_Records_FK

left join bvt_prod.Agency_LU_TBL as d
on b.Agency_LU_TBL=d.idAgency_LU_TBL

left join bvt_prod.Volume_Status_LU
on idVolume_Status_LU_FK=idVolume_Status_LU


where idProgram_Touch_Definitions_TBL_FK in (SELECT * FROM bvt_prod.Program_ID_Selector(6))
and InHome_Date >= '12/28/2015'
and b.idFlight_Plan_Records NOT IN (33500,33502)

group by
b.idFlight_Plan_Records
,Program_Name
,d.Agency
,Media
,Audience
,Campaign_Type
,Channel
,Scorecard_group
,Scorecard_program_Channel
,a.owner_type_matrix_id_FK
,a.idProgram_Touch_Definitions_TBL
,Tactic
,Volume_Type
,a.Touch_Name
,Budget_Calculation
,Campaign_Name
,InHome_Date
,TFN_ind
,URL_ind
,Adjustment_Reason
,Lead_Offer
,Strategy_Eligibility
,Offer_Test_1
,Offer_Test_2
,Media_Calendar_Daily.Date_Year
,Media_Calendar_Daily.Date_Month
,Volume_Status



end


GO


