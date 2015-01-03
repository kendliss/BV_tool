CREATE procedure [sandbox].[MSVP_Reporting_Query]

as

select Scorecard_Program_Channel, Aprimo_ID, [Cell ID], 
	[Creative Execution/Targeting], [Drop Date], Start_Date, End_Date_Traditional, In_Home_Date, 
	eCRW_Project_Name, Campaign_Name, Campaign_Description, 
	Campaign_Parent_Name, [English TFN], [Spanish TFN], Toll_Free_Numbers, media_code,
	[Target Group],
	
	budget,
	quantity,
    calls,
    online_response,
    WRLS_VOICE,
    WRLS_FAMILY,
    WRLS_DATA,
    WHP,		--wireless home phone added 1/21/2014
	DIRECTV,
     dsl_lineshare,
      dsl_dry,
      IPDSL,
      HSIA,
      Uverse_TV,
      access_line,
      voip,
   digital_life		--digital life added 1/21/2014
                              
       
	
	from (select [Cell ID], [Creative Execution/Targeting], [Drop Date], [English TFN],[Spanish TFN], join_tfn, [Target Group]
		from sandbox.Summary$ 
		group by [Cell ID], [Creative Execution/Targeting], [Drop Date], [English TFN], [Spanish TFN], join_tfn, [Target Group]) summary
		left join 
		
		(select Scorecard_Program_Channel, Aprimo_ID, Start_Date, End_Date_Traditional, In_Home_Date, 
	eCRW_Project_Name, Campaign_Name, Campaign_Description, 
	Campaign_Parent_Name, Toll_Free_Numbers, IR_Workbook_Data.media_code,
	sum(isnull(ITP_Budget_UnApp,0)) as budget,
	sum(isnull(ITP_Quantity_UnApp,0)) as quantity,
      sum(isnull(itp_dir_calls,0)) as calls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as online_response,
      sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)+isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)) as WRLS_VOICE,
      sum(            isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)) as WRLS_FAMILY,
      sum(            isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+isnull(ITP_Dir_Sales_ON_CING_DATA_N,0)) as WRLS_DATA,
      sum(            isnull(ITP_Dir_Sales_TS_CING_WHP_N,0)+isnull(ITP_Dir_Sales_ON_CING_WHP_N,0)) as WHP,		--wireless home phone added 1/21/2014
	  sum(		  isnull(itp_dir_sales_ts_dish_n,0)+ isnull(itp_dir_sales_on_dish_n,0)) as DIRECTV,
      sum(           isnull(itp_dir_sales_ts_dsl_reg_n,0)+isnull(itp_dir_sales_on_dsl_reg_n,0) ) as dsl_lineshare,
      sum(            isnull(itp_dir_sales_ts_dsl_dry_n,0)+isnull(itp_dir_sales_on_dsl_dry_n,0)) as dsl_dry,
      sum(            isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+isnull(ITP_Dir_Sales_ON_DSL_IP_N,0)) as IPDSL,
      sum(            isnull(itp_dir_sales_ts_uvrs_hsia_n,0)+isnull(itp_dir_sales_on_uvrs_hsia_n,0) ) as HSIA,
      sum(            isnull(itp_dir_sales_ts_uvrs_tv_n,0)+isnull(itp_dir_sales_on_uvrs_tv_n,0)) as Uverse_TV,
      sum(            isnull(itp_dir_sales_ts_local_accl_n,0)+isnull(itp_dir_sales_on_local_accl_n,0)) as access_line,
      sum(            isnull(itp_dir_sales_ts_uvrs_voip_n,0)+isnull(itp_dir_sales_on_uvrs_voip_n,0)) as voip,
      sum(            isnull(ITP_Dir_Sales_TS_DLIFE_N,0)+  isnull(ITP_Dir_Sales_ON_DLIFE_N,0) ) as digital_life	,
      case when left(Toll_Free_Numbers, 10) in (select join_tfn from  sandbox.Summary$) then left(Toll_Free_Numbers, 10)
       when right(Toll_Free_Numbers, 10) in (select join_tfn from  sandbox.Summary$) then right(Toll_Free_Numbers, 10)
       end as matching_tfn 
      from JAVDB.IREPORT_2014.dbo.IR_Workbook_Data
		inner join JAVDB.IREPORT_2014.dbo.ir_a_ownertypetactic_matrix
		on tactic_id=id 
		where start_date>='2014-05-19' and (left(Toll_Free_Numbers, 10) in (select join_tfn from  sandbox.Summary$)
				or right(Toll_Free_Numbers, 10) in (select join_tfn	from  sandbox.Summary$))
		group by Scorecard_Program_Channel, Aprimo_ID, Start_Date, End_Date_Traditional, In_Home_Date, 
	eCRW_Project_Name, Campaign_Name, Campaign_Description, 
	Campaign_Parent_Name, Toll_Free_Numbers, IR_Workbook_Data.media_code) workbook
	
ON 	matching_tfn= join_tfn
	
		
