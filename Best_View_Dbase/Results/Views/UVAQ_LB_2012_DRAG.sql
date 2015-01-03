
create view Results.UVAQ_LB_2012_DRAG

as select 
--Summary Variables
Report_Week,Report_Year, a.Media_Code as Media_Type, right(MediaMonth_YYYYMM,2) as Media_Month,

SUM(ITP_Dir_Calls) as Calls, 
--Sales
SUM(ITP_Dir_Sales_TS_CING_N) as Wireless_Call_Sales,
SUM(ITP_Dir_Sales_TS_CING_VOICE_N) as Wireless_Voice_Call_Sales,
SUM(ITP_Dir_Sales_TS_CING_FAMILY_N) as Wireless_Family_Call_Sales,
SUM(ITP_Dir_Sales_TS_CING_DATA_N) as Wireless_Data_Call_Sales,
SUM(ITP_Dir_Sales_TS_DISH_N) as DirectTV_Call_Sales,
SUM(ITP_Dir_Sales_TS_DSL_REG_N) as DSL_Direct_Call_Sales,
SUM(ITP_Dir_Sales_TS_DSL_DRY_N) as DSL_Dry_Loop_Call_Sales,
SUM(ITP_Dir_Sales_TS_DSL_IP_N) as IPDSLAM_Call_Sales,
SUM(ITP_Dir_Sales_TS_UVRS_HSIA_N) as HSIA_Call_Sales,
SUM(ITP_Dir_Sales_TS_LOCAL_ACCL_N) as Local_Call_Sales,
SUM(ITP_Dir_Sales_TS_UVRS_VOIP_N) as VOIP_Call_Sales,
SUM(ITP_Dir_Sales_TS_UVRS_TV_N) as UVERSE_TV_Call_Sales,

--Commitment View Data
SUM(CV_ITP_Dir_Calls) as CV_Calls, 
  --Sales
SUM(CV_ITP_Dir_Sales_TS_CING_VOICE+CV_ITP_Dir_Sales_TS_CING_FAMILY+CV_ITP_Dir_Sales_TS_CING_DATA) as CV_Wireless_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_CING_VOICE) as CV_Wireless_Voice_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_CING_FAMILY) as CV_Wireless_Family_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_CING_DATA) as CV_Wireless_Data_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_DISH) as CV_DirectTV_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_DSL_REG) as CV_DSL_Direct_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_DSL_DRY) as CV_DSL_Dry_Loop_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_DSL_IP) as CV_IPDSLAM_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_UVRS_HSIA) as CV_HSIA_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_ACCL) as CV_Local_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_UVRS_VOIP) as CV_VOIP_Call_Sales,
SUM(CV_ITP_Dir_Sales_TS_UVRS_TV) as CV_UVERSE_TV_Call_Sales



FROM JAVDB.IREPORT.dbo.IR_Campaign_Data_Weekly_MAIN_2012 as a join JAVDB.IREPORT.dbo.ir_a_ownertypetactic_matrix_20120509 as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing - Live Base'
and b.Scorecard_LOB_Tab = 'U-verse Live Base'

and Report_Year=2012 
	and a.Media_Code='DR' 
	--and PROGRAM= 'UVAQ'
	--and Dashboard_LOB='U-verse Live Base'
	--and Dashboard_Segment='U-verse Base Acq'
GROUP BY Report_Week, Report_Year, a.Media_Code,right(MediaMonth_YYYYMM,2)