select 
	Touch_Type_FK
	, link.idProgram_Touch_Definitions_TBL_FK
	, link.InHome_Date
	, [Touch_Name]
	, [idFlight_Plan_Records]
	, [Media_Week]
	, Calls
	, Clicks
	, [CV_Drop_Volume] as [BV_Drop_Volume]
, [CV_Call_TV_Sales] as [BV_Call_TV_Sales]
, [CV_Online_TV_Sales] as [BV_Online_TV_Sales]
, [CV_Call_HSIA_Sales] as [BV_Call_HSIA_Sales]
, [CV_Online_HSIA_Sales] as [BV_Online_HSIA_Sales]
, [CV_Call_VOIP_Sales] as [BV_Call_VOIP_Sales]
, [CV_Online_VOIP_Sales] as [BV_Online_VOIP_Sales]
, [CV_Call_DSL_Reg_Sales] as [BV_Call_DSL_Reg_Sales]
, [CV_Call_DSL_Dry_Sales] as [BV_Call_DSL_Dry_Sales]
, [CV_Call_Access_Sales] as [BV_Call_Access_Sales]
, [CV_Call_Wrls_Voice_Sales] as [BV_Call_Wrls_Voice_Sales]
, [CV_Call_Dish_Sales] as [BV_Call_Dish_Sales]
, [CV_Call_WRLS_Family_Sales] as [BV_Call_WRLS_Family_Sales]
, [CV_Call_WRLS_Data_Sales] as [BV_Call_WRLS_Data_Sales]
, [CV_Call_IPDSL_Sales] as [BV_Call_IPDSL_Sales]
, [CV_Online_DSL_Reg_Sales] as [BV_Online_DSL_Reg_Sales]
, [CV_Online_DSL_Dry_Sales] as [BV_Online_DSL_Dry_Sales]
, [CV_Online_Access_Sales] as [BV_Online_Access_Sales]
, [CV_Online_Wrls_Voice_Sales] as [BV_Online_Wrls_Voice_Sales]
, [CV_Online_Dish_Sales] as [BV_Online_Dish_Sales]
, [CV_Online_WRLS_Family_Sales] as [BV_Online_WRLS_Family_Sales]
, [CV_Online_WRLS_Data_Sales] as [BV_Online_WRLS_Data_Sales]
, [CV_Online_IPDSL_Sales] as [BV_Online_IPDSL_Sales]
, [CV_Directed_Strategic_Call_Sales] as [BV_Directed_Strategic_Call_Sales]
, [CV_Directed_Strategic_Online_Sales] as [BV_Directed_Strategic_Online_Sales]

into sandbox.UVLB_CV_2015_transformation

from

(select
	Touch_Type_FK
	, [NEW idProgram_Touch_Definitions_TBL] as idProgram_Touch_Definitions_TBL_FK
	, InHome_Date
	, [Touch_Name]
	, [Media_Week]
	, [CV_Calls] as calls
	, [CV_Clicks] as clicks
	, [CV_Drop_Volume]
, [CV_Call_TV_Sales]
, [CV_Online_TV_Sales]
, [CV_Call_HSIA_Sales]
, [CV_Online_HSIA_Sales]
, [CV_Call_VOIP_Sales]
, [CV_Online_VOIP_Sales]
, [CV_Call_DSL_Reg_Sales]
, [CV_Call_DSL_Dry_Sales]
, [CV_Call_Access_Sales]
, [CV_Call_Wrls_Voice_Sales]
, [CV_Call_Dish_Sales]
, [CV_Call_WRLS_Family_Sales]
, [CV_Call_WRLS_Data_Sales]
, [CV_Call_IPDSL_Sales]
, [CV_Online_DSL_Reg_Sales]
, [CV_Online_DSL_Dry_Sales]
, [CV_Online_Access_Sales]
, [CV_Online_Wrls_Voice_Sales]
, [CV_Online_Dish_Sales]
, [CV_Online_WRLS_Family_Sales]
, [CV_Online_WRLS_Data_Sales]
, [CV_Online_IPDSL_Sales]
, [CV_Directed_Strategic_Call_Sales]
, [CV_Directed_Strategic_Online_Sales]
from [Commitment_Versions].[CV_2015_Dec18Submission_v3] as old
	left join dbo.UVLB_Old_New_Transition_v2 as junction
	 on old.Touch_Type_FK=junction.[OLD Touch Type Fk] 
	)  as link

	left join [bvt_prod].[Flight_Plan_Records] as FPR
	 on link.idProgram_Touch_Definitions_TBL_FK=FPR.[idProgram_Touch_Definitions_TBL_FK] and link.Inhome_Date=FPR.[InHome_Date]
where calls>0 or clicks>0
