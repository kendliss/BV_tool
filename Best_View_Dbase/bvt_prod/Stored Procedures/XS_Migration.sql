DROP Proc bvt_prod.XS_Migration
GO

CREATE procedure [bvt_prod].[XS_Migration]

as

Select e. Report_Year, e. ReportWeek_YYYYWW, e.MediaMonth_YYYYMM, f.Scorecard_Type, f.Scorecard_Program_Channel, e.eCRW_Project_Name, e.Start_Date,

 --Quantity

	  isnull(sum(ITP_Quantity_UnApp),0) as ITP_QTY_UNAPP

--Calls
	  ,isnull(sum(ITP_Dir_Calls),0)as Calls
	  
--Online Reponse
      ,isnull(sum(ITP_Dir_Clicks),0)+isnull(sum(ITP_Dir_QRScans),0)as Online_Resp
      
--Total Response
	  ,isnull(sum(ITP_Dir_Calls),0)+isnull(sum(ITP_Dir_Clicks),0)+isnull(sum(ITP_Dir_QRScans),0) as Total_Response
	  
--Sales
	 ,isnull(sum(ITP_Dir_Sales_TS_CING_VOICE_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_CING_FAMILY_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_CING_DATA_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_CING_WHP_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DLIFE_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DISH_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DSL_REG_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DSL_DRY_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DSL_IP_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_HSIA_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_HSIAG_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_TV_N),0) +
      --isnull(sum(ITP_Dir_Sales_TS_UVRS_BOLT_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_LOCAL_ACCL_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_VOIP_N),0) as ITP_Dir_Sales_TS_Strat
      
     ,isnull(sum(ITP_Dir_Sales_ON_CING_VOICE_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_CING_FAMILY_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_CING_DATA_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_CING_WHP_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DLIFE_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DISH_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DSL_REG_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DSL_DRY_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DSL_IP_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_HSIA_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_HSIAG_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_TV_N),0) +
      --isnull(sum(ITP_Dir_Sales_ON_UVRS_BOLT_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_LOCAL_ACCL_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_VOIP_N),0) as ITP_Dir_Sales_ON_Strat
      
	 ,isnull(sum(ITP_Dir_Sales_TS_CING_VOICE_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_CING_FAMILY_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_CING_DATA_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_CING_WHP_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DLIFE_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DISH_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DSL_REG_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DSL_DRY_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_DSL_IP_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_HSIA_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_HSIAG_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_TV_N),0) +
      --isnull(sum(ITP_Dir_Sales_TS_UVRS_BOLT_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_LOCAL_ACCL_N),0) +
      isnull(sum(ITP_Dir_Sales_TS_UVRS_VOIP_N),0) +      
      isnull(sum(ITP_Dir_Sales_ON_CING_VOICE_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_CING_FAMILY_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_CING_DATA_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_CING_WHP_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DLIFE_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DISH_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DSL_REG_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DSL_DRY_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_DSL_IP_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_HSIA_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_HSIAG_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_TV_N),0) +
      --isnull(sum(ITP_Dir_Sales_ON_UVRS_BOLT_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_LOCAL_ACCL_N),0) +
      isnull(sum(ITP_Dir_Sales_ON_UVRS_VOIP_N),0) as Total_Dir_Sales
      
	 ,isnull(sum(ITP_Dir_Sales_TS_UVRS_HSIA_N),0) +
	  isnull(sum(ITP_Dir_Sales_TS_UVRS_HSIAG_N),0) +
	  isnull(sum(ITP_Dir_Sales_TS_DSL_IP_N),0) as HISA_IP_Sales_TS
	  
	 ,isnull(sum(ITP_Dir_Sales_ON_UVRS_HSIA_N),0) +
	  isnull(sum(ITP_Dir_Sales_ON_UVRS_HSIAG_N),0) +
	  isnull(sum(ITP_Dir_Sales_ON_DSL_IP_N),0) as HISA_IP_Sales_ON
	  
	 ,isnull(sum(ITP_Dir_Sales_TS_UVRS_VOIP_N),0) as VOIP_TS

	 ,isnull(sum(ITP_Dir_Sales_ON_UVRS_VOIP_N),0) as VOIP_ON

from bvt_prod.External_ID_linkage_TBL a
JOIN bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
on a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
JOIN bvt_prod.Flight_Plan_Records c
on b.idFlight_Plan_Records_FK = c.idFlight_Plan_Records
JOIN bvt_Prod.Touch_Definition_VW d
on d.idProgram_Touch_Definitions_TBL = c.idProgram_Touch_Definitions_TBL_FK
--JOIN JAVDB.IREPORT_2015.dbo.WB_04_Workbook_Data_2016 e
JOIN JAVDB.IREPORT_2015.dbo.IR_Workbook_Data_2016 e
ON a.Source_System_ID = e.ParentID
JOIN JAVDB.ireport_2015.dbo.WB_00_Reporting_Hierarchy_2016 f
ON e.tactic_id=f.id
WHERE (PROGRAM_NAME = 'X-Sell' and Touch_Name LIKE '%Mig%')
OR (PROGRAM_NAME = 'BM' and Touch_Name LIKE '%Migration%')
--OR (PROGRAM_NAME = 'UVLB' and (Touch_Name LIKE '%BBMig%' OR Touch_Name LIKE '%Wireline Migrator DTV%') AND MEDIA = 'FPC')
--OR (PROGRAM_NAME = 'VALB' and Touch_Name LIKE '%Mig%' AND MEDIA NOT IN ('DM','EM'))
OR (a.Source_System_ID in (243983,
243984,
243985,
243986,
243987,
243988,
243989,
243990,
249139,
249140,
249141,
249142,
253444,
253445,
256571,
256572))

GROUP BY e.Report_Year, e.MediaMonth_YYYYMM, e. ReportWeek_YYYYWW, f.Scorecard_Type, f.Scorecard_Program_Channel, e.eCRW_Project_Name, e.Start_Date







GO


