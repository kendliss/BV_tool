select 
	Touch_Type_FK
	, link.idProgram_Touch_Definitions_TBL_FK
	, link.InHome_Date
	, [Touch_Name]
	, [idFlight_Plan_Records]
	, [Media_Week]
	, Calls
	, Clicks
	, [BV_Drop_Volume]
, [BV_Call_TV_Sales]
, [BV_Online_TV_Sales]
, [BV_Call_HSIA_Sales]
, [BV_Online_HSIA_Sales]
, [BV_Call_VOIP_Sales]
, [BV_Online_VOIP_Sales]
, [BV_Call_DSL_Reg_Sales]
, [BV_Call_DSL_Dry_Sales]
, [BV_Call_Access_Sales]
, [BV_Call_Wrls_Voice_Sales]
, [BV_Call_Dish_Sales]
, [BV_Call_WRLS_Family_Sales]
, [BV_Call_WRLS_Data_Sales]
, [BV_Call_IPDSL_Sales]
, [BV_Online_DSL_Reg_Sales]
, [BV_Online_DSL_Dry_Sales]
, [BV_Online_Access_Sales]
, [BV_Online_Wrls_Voice_Sales]
, [BV_Online_Dish_Sales]
, [BV_Online_WRLS_Family_Sales]
, [BV_Online_WRLS_Data_Sales]
, [BV_Online_IPDSL_Sales]
, [BV_Directed_Strategic_Call_Sales]
, [BV_Directed_Strategic_Online_Sales]

into sandbox.UVLB_CV_2015_transformation

from

(select
	Touch_Type_FK
	, [NEW idProgram_Touch_Definitions_TBL] as idProgram_Touch_Definitions_TBL_FK
	, InHome_Date
	, [Touch_Name]
	, [Media_Week]
	, [BV_Calls] as calls
	, [BV_Clicks] as clicks
	, [BV_Drop_Volume]
, [BV_Call_TV_Sales]
, [BV_Online_TV_Sales]
, [BV_Call_HSIA_Sales]
, [BV_Online_HSIA_Sales]
, [BV_Call_VOIP_Sales]
, [BV_Online_VOIP_Sales]
, [BV_Call_DSL_Reg_Sales]
, [BV_Call_DSL_Dry_Sales]
, [BV_Call_Access_Sales]
, [BV_Call_Wrls_Voice_Sales]
, [BV_Call_Dish_Sales]
, [BV_Call_WRLS_Family_Sales]
, [BV_Call_WRLS_Data_Sales]
, [BV_Call_IPDSL_Sales]
, [BV_Online_DSL_Reg_Sales]
, [BV_Online_DSL_Dry_Sales]
, [BV_Online_Access_Sales]
, [BV_Online_Wrls_Voice_Sales]
, [BV_Online_Dish_Sales]
, [BV_Online_WRLS_Family_Sales]
, [BV_Online_WRLS_Data_Sales]
, [BV_Online_IPDSL_Sales]
, [BV_Directed_Strategic_Call_Sales]
, [BV_Directed_Strategic_Online_Sales]
from Commitment_Versions.CV_2015_Nov26Submission as old
	left join dbo.UVLB_Old_New_Transition_v2 as junction
	 on old.Touch_Type_FK=junction.[OLD Touch Type Fk] 
	)  as link

	left join [bvt_prod].[Flight_Plan_Records] as FPR
	 on link.idProgram_Touch_Definitions_TBL_FK=FPR.[idProgram_Touch_Definitions_TBL_FK] and link.Inhome_Date=FPR.[InHome_Date]
where calls>0 or clicks>0
