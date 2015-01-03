CREATE TABLE [Forecasting].[Media_Type] (
    [Media_Type_ID]   INT         IDENTITY (1, 1) NOT NULL,
    [Media_Type]      VARCHAR (8) NOT NULL,
    [Media_Type_Desc] TEXT        NULL,
    PRIMARY KEY CLUSTERED ([Media_Type_ID] ASC)
);

