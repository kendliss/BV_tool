CREATE TABLE [Forecasting].[Audience] (
    [Audience_ID]        INT         IDENTITY (1, 1) NOT NULL,
    [Audience_Type_Name] VARCHAR (8) NOT NULL,
    [Audience_Type_Desc] TEXT        NULL,
    PRIMARY KEY CLUSTERED ([Audience_ID] ASC)
);

