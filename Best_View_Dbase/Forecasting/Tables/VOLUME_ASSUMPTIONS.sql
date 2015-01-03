CREATE TABLE [Forecasting].[VOLUME_ASSUMPTIONS] (
    [Volume_Assumption_ID] INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]        INT        NOT NULL,
    [Volume_Assumption]    FLOAT (53) NOT NULL,
    [Entry_Metadata_FK]    INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Volume_Assumption_ID] ASC),
    FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id])
);

