ALTER VIEW [bvt_prod].[Daily_Response_Curve_ecrwcellid_VW]
	AS 

------Acquisition Curves by day by parentid	
	SELECT 
		parentid
		, case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,curve.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,curve.Week_ID,InHome_Date))
			end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[ACQ_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](8)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](8)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
-------------End of Acquisition Query------------------------------------
	UNION

------X Sell Curves by day by parentid
	SELECT 
		parentid
		, case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,curve.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,curve.Week_ID,InHome_Date))
			end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[XSell_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](6)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](6)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
---------------------------End of X Sell Query--------------------
	UNION
/*Block retention Curves as no longer managing
------------Retention Curves by day by parentid----------------------
	SELECT 
		parentid
		, DATEADD(day,curve.Week_ID,InHome_Date) as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent
		, daily_perc.idProgram_Touch_Definitions_TBL_FK 
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[UCLM_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](3)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](3)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------------End of Retention Query-----------------------

union*/

----------Revenue Curves by day by parentid----------------------
	SELECT 
		parentid
		, case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,curve.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,curve.Week_ID,InHome_Date))
			end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[CLM_Revenue_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](9)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](9)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
---added to fix screwed up daily forecast problem due's to revenue's unique curves
	where Day_of_Week=DATEPART(weekday,DATEADD(day,curve.Week_ID,InHome_Date))
------------------End Revenue Query-------------------------------------
UNION
-------------------Movers Curves by day by parentid-----------------------
	SELECT 
		parentid
		, case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,curve.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,curve.Week_ID,InHome_Date))
			end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[Movers_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](4)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](4)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------------End Movers Query------------------------
/*UNION
------------------Historic VALB BV-------------------------
	SELECT 
		parentid
		, DATEADD(day,Day_of_Week,DATEADD(week,curve.Week_ID-1,InHome_Date)) as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[VALB_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](2)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](2)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------END VALB Query-----------------------------------
UNION
-------------Historic UVLB Query----------------------------------
SELECT 
		parentid
		, DATEADD(day,Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date)) as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[UVLB_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](1)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](1)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------END UVLB Query-----------------------------------
	*/UNION

------Email Curves by day by parentid
	SELECT 
		parentid
		, case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,curve.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,curve.Week_ID,InHome_Date))
			end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[Email_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](11)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](11)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
	UNION

------Mig Curves by day by parentid
	SELECT 
		parentid
		, DATEADD(day,Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date)) as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[Mig_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](12)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](12)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE

		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk

union
------CSBM Curves by day by parentid
	SELECT 
		parentid
		, case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,curve.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,curve.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,curve.Week_ID,InHome_Date))
			end as Forecast_DayDate
		, daily_perc.idKPI_TYPE_fk
		, Day_Percent*week_percent as response_percent 
		, daily_perc.idProgram_Touch_Definitions_TBL_FK
	FROM

	(select parentid, campaigns.idProgram_Touch_Definitions_TBL_FK, InHome_Date, Day_of_Week, day_percent, idkpi_type_fk	
	
	FROM 
	
	(select source_system_id as parentid, idProgram_Touch_Definitions_TBL_FK, InHome_Date
	
		from [bvt_prod].[BM_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
 where idSource_system_LU_FK=2 and idSource_Field_Name_LU_FK=2
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN](7)) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN](7)) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
