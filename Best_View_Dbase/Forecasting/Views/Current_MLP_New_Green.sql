CREATE VIEW Forecasting.Current_MLP_New_Green WITH SCHEMABINDING

AS SELECT A.MLP_Version, A.MLP_Year, A.MLP_Month, 
	CASE WHEN A.MLP_Month <> 1 then (A.Expr1 + A.Expr1*0.0018 - (Select B.Expr1 from Forecasting.Current_MLP_Summary_View as B where B.MLP_Month=A.MLP_Month-1 and B.MLP_Year=A.MLP_Year))
	ELSE (A.Expr1 + A.Expr1*0.0018 - (Select B.Expr1 from Forecasting.Current_MLP_Summary_View as B where B.MLP_Month=12 and B.MLP_Year=A.MLP_Year-1))
	END AS New_Green_ELU
FROM Forecasting.Current_MLP_Summary_View as A 
