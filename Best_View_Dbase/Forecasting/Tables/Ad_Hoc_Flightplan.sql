CREATE TABLE [Forecasting].[Ad_Hoc_Flightplan] (
    [Ad_Hoc_Flightplan_ID] INT          IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]        INT          NOT NULL,
    [InHome_Date]          DATETIME     NOT NULL,
    [Target_Type_FK]       INT          NOT NULL,
    [Target_Value]         FLOAT (53)   NOT NULL,
    [Decile_Targeted]      FLOAT (53)   NULL,
    [Budget_Given]         FLOAT (53)   NULL,
    [prj450_job_cd]        VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Ad_Hoc_Flightplan_ID] ASC)
);

