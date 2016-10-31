CREATE TABLE [bvt_prod].[Target_Rate_Adjustment_Manual_TBL]
(
	[idTarget_Adj_Manual] INT IDENTITY (1, 1) NOT NULL
	, [idKPI_Types_FK] int not null
	, [idReason_FK] int 
	, Adjustment float
	, PRIMARY KEY CLUSTERED ([idTarget_Adj_Manual] ASC)
	, FOREIGN KEY (idKPI_types_FK) REFERENCES [bvt_prod].KPI_Types (idKPI_Types)
)
