
CREATE VIEW Forecasting.Best_Available_Tactic

AS

------------------------------------------------- Pull in Touch Info ----------------------------------------------------------
Select Available_Vol_by_ID.Touch_Type_FK
      ,Touch_Name.Media_Type
      ,(Touch_Name.Touch_Name + ' ' + Touch_Name.Touch_Name_2) as Project
	  ,Touch_Name.Touch_Name
      ,Touch_Name.Touch_Name_2
      ,Touch_Name.Cost_Per_Piece
	  ,Available_Vol_by_ID.[year]
	  ,Available_Vol_by_ID.[month]
	  ,Available_Vol_by_ID.Percent_Target
	  ,Available_Vol_by_ID.TV_CPS
	  ,Available_Vol_by_ID.Decile_Volume_Forecast
	  ,Available_Vol_by_ID.Available_Decile_Volume

From


------------------------------------------------- Query to pull Available Volumes by Touch_Type_FK ----------------------------------------------------------
(Select Available_Decile_Query.Touch_Type_FK
	  ,Available_Decile_Query.[year]
	  ,Available_Decile_Query.[month]
	  ,Available_Decile_Query.Percent_Target
	  ,Available_Decile_Query.TV_CPS
	  ,Available_Decile_Query.Decile_Volume_Forecast
	  ,MLP_Volumes.MLP_Decile_Volume as Available_Decile_Volume

From

---------  Pull CPP by Touch Type for available Deciles  ---------    

(Select Best_Tactic_CPS_by_Decile.Touch_Type_FK
	, Best_Tactic_CPS_by_Decile.[Year]
	,Best_Tactic_CPS_by_Decile.[Month]
	, Best_Tactic_CPS_by_Decile.Percent_Target
	, Best_Tactic_CPS_by_Decile.TV_CPS
	,(Volume_by_Touch.Volume_Forecast)/(Volume_by_Touch.Percent_Target*10) as Decile_Volume_Forecast
	
From 

(Select 
	  CPS_Query.Touch_Type_FK
	, Month_List_Query.[Year]
	, Month_List_Query.[Month]
	, CPS_Query.Percent_Target
	, CPS_Query.TV_CPS
	
From

----- Collect Months ----
(Select [Month]
		,right(Month_Year,4) as [Year]
		,MediaMonth_YYYYMM

From DIM.Media_Calendar

where MediaMonth_YYYYMM > '201152' 

Group by [Month],right(Month_Year,4),MediaMonth_YYYYMM ) as Month_List_Query,

------ Pull CPS by Touch Type/Decile ------

(select Touch_Type_FK 
	, Percent_Target
	, Cost_Per_Piece/sum(TV_Sales_Rate) as TV_CPS
	
FROM 

-----Calculate Call and Click TV Sales Rates
(select A.Touch_Type_FK
	, G.Percent_Target
	, A.Response_Channel_FK
	, Cost_Per_Piece
	, Response_Rate*Conversion_Rate*Adjustment_Factor*Call_Percent_of_Sales as TV_sales_rate

	from Forecasting.Most_Recent_Conversions_View as A
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as D
			ON A.Touch_Type_FK=D.Touch_Type_FK
		INNER JOIN Forecasting.Products as E
			ON D.Product_FK=E.Product_ID
		INNER JOIN Forecasting.Most_Recent_RR_Assumptions as F
			ON F.Touch_Type_FK=A.Touch_Type_FK
		INNER JOIN Forecasting.Most_Recent_Decile_Adjustments as G
			on G.Touch_Type_FK=A.Touch_Type_FK
		INNER JOIN Forecasting.Most_Recent_CPP_Assumptions as H
			ON H.Touch_Type_FK=A.Touch_Type_FK
		WHERE Product_FK=1 and Product_ID=1) as Sale_Rate_Query

---Join to CPP Assumptions to calculate cost per sale		

GROUP BY 
	Touch_Type_FK 
	, Percent_Target
	, Cost_Per_Piece ) as CPS_Query ) as Best_Tactic_CPS_by_Decile


left join 

(SELECT Forecast_Volume.Flight_Plan_Record_ID
	  ,Forecast_Volume.InHome_Date
	  ,Forecast_Volume.[Month]
	  ,Forecast_Volume.[Year]
	  ,Forecast_Volume.Touch_Type_FK
	  ,Forecast_Volume.Target_Type_Name
      ,(Target_Deciles.Decile_Targeted/10) as Percent_Target
	  ,sum(Forecast_Volume.Volume_Forecast) as Volume_Forecast
      ,sum(Forecast_Volume.Budget_Forecast) as CPP_Forecast

FROM      
  ----- SubQuery to pull Forecast Volume -----
(SELECT Flight_Plan_Record_ID
		,InHome_Date
		,Datepart("MM",InHome_Date) as [Month]
		,Datepart("YYYY",InHome_Date) as [Year] 
		,Touch_Type_FK
		,Target_Type_Name
		,sum(Volume_Forecast) as Volume_Forecast
		,sum(Budget_Forecast) as Budget_Forecast
  
  FROM UVAQ.Forecasting.Current_UVAQ_Flightplan_Forecast_View
  where Target_Type_Name = 'Volume' and 
		InHome_Date > '12/27/11'
  
  Group by  Flight_Plan_Record_ID
		   ,InHome_Date
		   ,Touch_Type_FK
		   ,Target_Type_Name ) 
     AS Forecast_Volume
     
Left Join  

  ----- SubQuery to Pull Targeted Deciles ------
(SELECT Flight_Plan_Record_ID
	   ,Touch_Type_FK
       ,InHome_Date
       ,Decile_Targeted
  FROM UVAQ.Forecasting.Flight_Plan_Records
  
  Group by 
	   Flight_Plan_Record_ID
	  ,Touch_Type_FK
      ,InHome_Date
      ,Decile_Targeted) as Target_Deciles

on Forecast_Volume.Flight_Plan_Record_ID = Target_Deciles.Flight_Plan_Record_ID
   
Group by 
	   Forecast_Volume.Flight_Plan_Record_ID
	  ,Forecast_Volume.InHome_Date
	  ,Forecast_Volume.[Month]
	  ,Forecast_Volume.[Year]
	  ,Forecast_Volume.Touch_Type_FK
	  ,Forecast_Volume.Target_Type_Name
      ,Target_Deciles.Decile_Targeted) as Volume_by_Touch

on Best_Tactic_CPS_by_Decile.Touch_Type_FK = Volume_by_Touch.Touch_Type_FK and
   Best_Tactic_CPS_by_Decile.[Year] = Volume_by_Touch.[Year] and
   Best_Tactic_CPS_by_Decile.[Month] = Volume_by_Touch.[Month] 
   
WHERE Best_Tactic_CPS_by_Decile.Percent_Target>Volume_by_Touch.Percent_Target or Volume_by_Touch.Percent_Target is null

/*Group by 
#Best_Tactic_CPS_by_Decile.Touch_Type_FK
	, #Best_Tactic_CPS_by_Decile.[Year]
	,#Best_Tactic_CPS_by_Decile.[Month]
	, #Best_Tactic_CPS_by_Decile.Percent_Target
	, #Best_Tactic_CPS_by_Decile.TV_CPS

Order by 
#Best_Tactic_CPS_by_Decile.Touch_Type_FK
	, #Best_Tactic_CPS_by_Decile.[Year]
	,#Best_Tactic_CPS_by_Decile.[Month]
	, #Best_Tactic_CPS_by_Decile.Percent_Target
	, #Best_Tactic_CPS_by_Decile.TV_CPS
*/
)  as Available_Decile_Query

Left Join

-------- Pull MLP Volume by Decile -------

(Select  Forecasting.Most_Recent_Volume_Assumptions.Touch_Type_FK
	   ,MLP_Monthly_Volumes.MLP_Month
	   ,((MLP_Monthly_Volumes.MLP_Volume*Forecasting.Most_Recent_Volume_Assumptions.Volume_Assumption)/10) as MLP_Decile_Volume
from

(SELECT 
		Forecasting.Current_MLP_Summary_View.MLP_Month
	   ,sum(Forecasting.Current_MLP_Summary_View.Expr1) as MLP_Volume

FROM  
Forecasting.Current_MLP_Summary_View

where MLP_Year = '2012'

Group By 
	   Forecasting.Current_MLP_Summary_View.MLP_Month

) as MLP_Monthly_Volumes, Forecasting.Most_Recent_Volume_Assumptions

) as MLP_Volumes

On  Available_Decile_Query.Touch_Type_FK = MLP_Volumes.Touch_Type_FK
	and
	Available_Decile_Query.[month]=MLP_Volumes.MLP_Month
	
/*
Order By
		   Available_Decile_Query.Touch_Type_FK
		  ,Available_Decile_Query.[year]
		  ,Available_Decile_Query.[month]
		  ,Available_Decile_Query.Percent_Target
		  ,Available_Decile_Query.TV_CPS
		  ,Available_Decile_Query.Decile_Volume_Forecast
		  ,MLP_Volumes.MLP_Decile_Volume
*/
) AS Available_Vol_by_ID
	
Left Join

------------------------------------------------- Pull Touch Info ----------------------------------------------------------

(SELECT Touch_Type_id
	   ,Touch_Name
       ,Touch_Name_2
       ,Media_Type
       ,Cost_Per_Piece
  FROM UVAQ.Forecasting.Touch_Type 
  inner join UVAQ.Forecasting.Media_Type
	ON Media_Type_FK=Media_Type_ID
  inner join UVAQ.Forecasting.Most_Recent_CPP_Assumptions
	ON Touch_Type_id=Touch_Type_FK
  Group By Touch_Type_id
		  ,Touch_Name
		  ,Touch_Name_2
		  ,Media_Type
		  ,Cost_Per_Piece) as Touch_Name
		  
On   Available_Vol_by_ID.Touch_Type_FK=Touch_Name.Touch_Type_id

where 
	1 = case when Touch_Type_FK in (32,56,43,48,31,55,30,56) then 0
	when Media_Type in ('EM','BI','FYI','SMS') then 0
	when touch_Name_2 like '%Launch%' then 0
	when touch_name_2 like '%BL%' then 0
	when touch_name like '%Touch%'then 0
	when (Media_Type = 'CA' and [month] in (1,3,5,7,9,11)) then 0
	when (Media_Type = 'DM' and [month] in (2,4,6,8,10,12)) then 0
	else 1
	end

/*
Order by Available_Vol_by_ID.Touch_Type_FK
      ,Touch_Name.Media_Type_FK
	  ,Touch_Name.Touch_Name
      ,Touch_Name.Touch_Name_2
	  ,Available_Vol_by_ID.[year]
	  ,Available_Vol_by_ID.[month]
	  ,Available_Vol_by_ID.Percent_Target
	  ,Available_Vol_by_ID.TV_CPS
	  ,Available_Vol_by_ID.Decile_Volume_Forecast
	  ,Available_Vol_by_ID.Available_Decile_Volume
*/	  


