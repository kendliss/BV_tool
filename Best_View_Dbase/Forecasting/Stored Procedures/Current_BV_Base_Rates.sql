create procedure forecasting.Current_BV_Base_Rates
as

----------------------------------------------------------------------
--base response rates
----------------------------------------------------------------------
if object_id('tempdb..#RR') is not null drop table #RR
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as UVTV_Conversion_Rate
	into #RR
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=1
order by Response_Channel, a.Touch_Type_FK
