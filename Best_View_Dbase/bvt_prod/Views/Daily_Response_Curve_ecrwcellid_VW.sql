ALTER VIEW [bvt_prod].[Daily_Response_Curve_ecrwcellid_VW]
	AS 
Select 
	parentid
		, case when [idMedia_LU_TBL_FK]=2 then
		case when day_of_week=1 then DATEADD(week,Week_ID,InHome_Date)
			else DATEADD(day,day_of_week-1,DATEADD(week,Week_ID,Inhome_Date))
			end
	  else 
	    case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,Week_ID,InHome_Date))
			end 
	  end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
FROM

(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk, [idMedia_LU_TBL_FK]	
	
FROM 

(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date, [idMedia_LU_TBL_FK]
	
		from [bvt_prod].[Flight_Plan_Records]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
		inner join [bvt_prod].[Program_Touch_Definitions_TBL]
			on idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	and idProgram_LU_TBL_FK not in (1,2,3,5,10)
group by source_system_id, [idMedia_LU_TBL_FK], idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns

left join [bvt_processed].[Response_Daily_Start_End] as daily
	on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
	and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
left join [bvt_processed].[Response_Curve_Start_End] as curve
	on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
	and inhome_date between Curve_Start_Date and curve.END_DATE
	and daily_perc.idkpi_type_FK=curve.idkpi_type_fk