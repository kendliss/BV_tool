
CREATE VIEW Forecasting.Assumptions_View_2013 
  
  
AS  
SELECT  a.* , b.Agency, c.Program_Owner
from Forecasting.Current_UVAQ_Flightplan_Forecast_View as a
left join Forecasting.Touch_Type as b on b.Touch_Type_id = a.Touch_Type_FK
left join Forecasting.Program_Owners as c on c.Program_Owner_ID = b.Program_Owner_FK