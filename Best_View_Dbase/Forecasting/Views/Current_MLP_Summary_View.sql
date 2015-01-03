CREATE VIEW Forecasting.Current_MLP_Summary_View WITH SCHEMABINDING
AS SELECT MLP_Version, MLP_Month, MLP_Year, SUM(ELU_Forecast) as Expr1
FROM Forecasting.MLP
WHERE MLP_Version = (select max(MLP_Version) from Forecasting.MLP)
GROUP BY MLP_Version, MLP_Month, MLP_Year
