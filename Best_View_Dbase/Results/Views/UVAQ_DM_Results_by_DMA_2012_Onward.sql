
create view Results.UVAQ_DM_Results_by_DMA_2012_Onward
as 

select parentid, project, tfn, 
start_date, end_date_traditional, DMA_CD,  major_join.report_week,  major_join.report_year, major_join.MediaMonth_YYYYMM,

case when major_join.report_week=[iso_week] and major_join.report_year=MediaMonth_Year and major_join.mediamonth_YYYYMM=calendar.mediamonth_YYYYMM then volume
else 0 end as volume, 

calls, UVTV_Call_Sales, HSIA_Sales, VoIP_Sales

from

(select
A.parentid, (touch_name + ' ' +touch_name_2) as project, A.tfn, 
start_date, end_date_traditional, a.DMA_CD, report_week, report_year, MediaMonth_YYYYMM,
volume, calls, tv_sales as UVTV_Call_Sales, HSIA_Sales, VoIP_Sales

from Results.Aspen_Volumes as A
	
	inner join 
	
	(select b.parentid, b.tfn, b.start_date, b.end_date_traditional, b.DMA_CD, 
		c.report_week, c.report_year, c.MediaMonth_YYYYMM, 
		calls, tv_sales, HSIA_Sales, VoIP_Sales
	from
	Results.UVAQ_Calls_by_DMA_parentid_tfn as B
	INNER JOIN	Results.Uverse_LB_Sales_by_dma_week as C
		ON ltrim(rtrim(B.parentid))=ltrim(rtrim(C.parentid)) 
		and ltrim(rtrim(b.TFN))=ltrim(rtrim(c.TFN)) 
		and ltrim(rtrim(b.DMA_CD))=ltrim(rtrim(c.DMA_CD))
		and b.media_week=c.report_week
		and b.mediamonth_year=c.report_year
		and b.mediamonth_YYYYMM=c.mediamonth_YYYYMM
	group by  b.parentid, b.tfn, b.start_date, b.end_date_traditional, b.DMA_CD, 
		c.report_week, c.report_year, c.MediaMonth_YYYYMM, calls, tv_sales, HSIA_Sales, VoIP_Sales) as BB
		
	on ltrim(rtrim(a.parentid))=ltrim(rtrim(bb.parentid)) 
		and ltrim(rtrim(a.TFN))=ltrim(rtrim(bb.TFN)) 
		and ltrim(rtrim(a.DMA_CD))=ltrim(rtrim(bb.DMA_CD))
		
	inner join 
	
		(select parentid, touch_name, touch_name_2 from
			Results.ParentID_Touch_Type_Link AS AA
			inner join Forecasting.Touch_Type as cc
			ON AA.touch_type_fk=cc.touch_type_id
			group by parentid, touch_name, touch_name_2) as dd
		
		
		ON A.PARENTID=dd.parentid
	
	group by A.parentid, (touch_name + ' ' +touch_name_2), A.tfn, start_date, end_date_traditional, 
		a.DMA_CD, report_week, report_year, MediaMonth_YYYYMM,
		volume, calls, tv_sales, HSIA_Sales, VoIP_Sales) as major_join
	
	inner join JAVDB.IREPORT.dbo.IR_A_Media_Calendar_Daily as calendar
		ON major_join.start_date=calendar.[date]
		
	group by parentid, project, tfn, 
start_date, end_date_traditional, DMA_CD,  major_join.report_week,  major_join.report_year, major_join.MediaMonth_YYYYMM,

case when major_join.report_week=iso_week and major_join.report_year=MediaMonth_Year and major_join.mediamonth_YYYYMM=calendar.mediamonth_YYYYMM then volume
else 0 end, calls, UVTV_Call_Sales, HSIA_Sales, VoIP_Sales
		
		
	
		
		
