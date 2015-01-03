create view Forecasting.Flight_Plan_Record_job_cd_entry
as select touch_name, touch_name_2, Media_type, Audience_type_name as audience, inhome_date, month(inhome_date) as inhome_month, year(inhome_date) as inhome_year, prj450_job_cd
from Forecasting.Flight_Plan_Records as A
	inner join Forecasting.Touch_Type as B on A.touch_type_fk=b.touch_type_id
	inner join Forecasting.Media_Type as C on b.media_type_fk=c.media_type_id
	inner join forecasting.audience as D on b.audience_fk=d.audience_id
where flight_plan_fk = (select flight_plan_id from Forecasting.Most_Recent_FlightPlan_View where program_id=1)