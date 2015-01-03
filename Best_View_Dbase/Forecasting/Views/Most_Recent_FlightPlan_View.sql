CREATE VIEW Forecasting.Most_Recent_FlightPlan_View WITH SCHEMABINDING 
AS SELECT      MAX(Forecasting.Flight_Plan.Flight_Plan_ID) AS Flight_Plan_ID, Forecasting.Program.Program_ID, Forecasting.Program.Program
FROM          Forecasting.Flight_Plan INNER JOIN
                        Forecasting.Program ON Forecasting.Flight_Plan.Program_FK = Forecasting.Program.Program_ID
GROUP BY Forecasting.Program.Program_ID, Forecasting.Program.Program