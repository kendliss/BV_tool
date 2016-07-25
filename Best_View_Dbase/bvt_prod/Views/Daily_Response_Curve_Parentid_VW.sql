alter VIEW [bvt_prod].[Daily_Response_Curve_Parentid_VW]
	AS 

------Acquisition Curves by day by parentid	
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
	
		from [bvt_prod].[ACQ_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('ACQ')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('ACQ')) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
-------------End of Acquisition Query------------------------------------
	UNION

------X Sell Curves by day by parentid
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
	
		from [bvt_prod].[XSell_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('X-Sell')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('X-Sell')) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
---------------------------End of X Sell Query--------------------
	UNION

------------Retention Curves by day by parentid----------------------
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
	
		from [bvt_prod].[UCLM_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('UVCLM')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('UVCLM')) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------------End of Retention Query-----------------------

union

----------Revenue Curves by day by parentid----------------------
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
	
		from [bvt_prod].[CLM_Revenue_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('UCLM Revenue')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('UCLM Revenue')) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------------End Revenue Query-------------------------------------
UNION
-------------------Movers Curves by day by parentid-----------------------
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
	
		from [bvt_prod].[Movers_Flight_Plan_VW]
	
		inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]
			on idFlight_Plan_Records=idFlight_Plan_Records_FK
		inner join [bvt_prod].[External_ID_linkage_TBL]
			on [idExternal_ID_linkage_TBL]=[idExternal_ID_linkage_TBL_FK]
	group by source_system_id, idProgram_Touch_Definitions_TBL_FK, InHome_Date) as campaigns
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('MOVERS')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('MOVERS')) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
------------------End Movers Query------------------------
UNION
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
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('VALB')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('VALB')) as curve
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
	
	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('UVLB')) as daily
		on campaigns.idProgram_Touch_Definitions_TBL_FK=daily.idProgram_Touch_Definitions_TBL_FK 
		and InHome_Date between daily_Start_Date and daily.END_DATE) as daily_perc
	
	left join (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('UVLB')) as curve
		on daily_perc.idProgram_Touch_Definitions_TBL_FK=curve.idProgram_Touch_Definitions_TBL_FK 
		and inhome_date between Curve_Start_Date and curve.END_DATE
		and daily_perc.idkpi_type_FK=curve.idkpi_type_fk
