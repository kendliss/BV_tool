CREATE TABLE [Forecasting].[Flight_plan_records_archive] (
    [Flight_Plan_Record_ID] INT        NULL,
    [Flight_Plan_FK]        INT        NULL,
    [Touch_Type_FK]         INT        NULL,
    [InHome_Date]           DATETIME   NULL,
    [Target_Type_FK]        INT        NULL,
    [Target_Value]          FLOAT (53) NULL,
    [Decile_Targeted]       FLOAT (53) NULL,
    [Budget_Given]          FLOAT (53) NULL
);

