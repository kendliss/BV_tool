

CREATE PROCEDURE [eCRW].[weekly_report_fusion92]
as
if object_id('eCRW.weekly_report_for_fusion92') is not null drop table eCRW.weekly_report_for_fusion92
select a.[Channel]
,a.[First Drop Date/ Track Start]
,a.[In-Home Date]
,a.[Campaign Name]
,a.[Cell Title]
,a.ParentID
,a.[TFN]
,a.[TFN Type]
,a.[URL]
,a.[Quantity]
,a.[Call RR]
,a.[Click RR]
,case when a.ParentID not IN (select parentid 
								from javdb.ireport.dbo.IR_Campaign_Data_Latest_MAIN_2012 as a 
									join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
									on a.tactic_id=b.id
								where report_year >=2013
								and b.Scorecard_Top_Tab = 'Direct Marketing'
								and b.Scorecard_LOB_Tab = 'U-verse'
								and b.Scorecard_tab in ('Uverse')
								group by parentid) then 'Y'
	else 'N'
	end as [New Parentid]
into eCRW.weekly_report_for_fusion92
from eCRW.weekly_report_data as a left join javdb.ireport.dbo.eCRW_Final_project_URL_view as b
	on (a.[Campaign ID]=b.project_id and a.[Cell Title]=b.TFN_Description)
where [In-home Date] >= '2013-07-01'  
and a.[Cell Title] not like '%control%'
and a.[Cell Title] not like '%CTL%'
and a.[Cell Title] not like '%CKLTR%'
and a.[Cell Title] not like '%CKLT%'
and (b.vanity_url like '%better%' or a.[URL] like 'NULL'
	or a.[Cell Title] like '%fusion%' 
	or a.[Cell Title] like '%orlan%'
	or a.[Cell Title] like '%san fran%'
	or a.[Cell Title] like '%miami%'
	or a.[Cell Title] like '%DH%'
	or a.[Cell Title] like '%chi%'
	or a.[Cell Title] like '%det%'
	or a.[Campaign Name] like '%local%'
	or a.[Cell Title] like '% go local%'
	or b.url_desc like '%fusion%'
	--my edit
	or a.[Cell Title] like '%nash$'
	------
	)
and URL not like '%uverse%'
and a.[Cell Title] not like '%WLN/WLS PC Non Lam 79 TP+150%'
group by a.[Channel]
,a.[First Drop Date/ Track Start]
,a.[In-Home Date]
,a.[Campaign Name]
,a.[Cell Title]
,a.ParentID
,a.[TFN]
,a.[TFN Type]
,a.[URL]
,a.[Quantity]
,a.[Call RR]
,a.[Click RR]
order by a.[Channel]
,a.[First Drop Date/ Track Start]
,a.[In-Home Date]
,a.[Campaign Name]
,a.[Cell Title]
,a.ParentID
,a.[TFN]
,a.[TFN Type]
,a.[URL]
,a.[Quantity]
,a.[Call RR]
,a.[Click RR]
select * from eCRW.weekly_report_for_fusion92

