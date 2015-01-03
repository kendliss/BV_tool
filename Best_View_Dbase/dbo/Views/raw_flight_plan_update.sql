
create view raw_flight_plan_update 
 as select * from forecasting.flight_plan_records
 where flight_plan_fk= (select flight_plan_id from Forecasting.Most_Recent_FlightPlan_View)
 and touch_type_fk in (70,74,78,82) 