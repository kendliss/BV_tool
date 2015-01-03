CREATE TABLE [Forecasting].[Target_Type] (
    [Target_Type_ID]   INT         IDENTITY (1, 1) NOT NULL,
    [Target_Type_Name] VARCHAR (8) NOT NULL,
    [Target_Type_Desc] TEXT        NULL,
    PRIMARY KEY CLUSTERED ([Target_Type_ID] ASC)
);

