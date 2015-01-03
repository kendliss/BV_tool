CREATE TABLE [Forecasting].[Seasonality] (
    [Media_Type_FK]     INT        NULL,
    [Seasonality_Month] INT        NULL,
    [Seasonality_Index] FLOAT (53) NULL,
    [Entry_Metadata_FK] INT        NULL,
    [Seasonality_ID]    INT        IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Seasonality] PRIMARY KEY CLUSTERED ([Seasonality_ID] ASC),
    CONSTRAINT [FK_Season_ENTRY_METADATA] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    CONSTRAINT [FK_Season_Media] FOREIGN KEY ([Media_Type_FK]) REFERENCES [Forecasting].[Media_Type] ([Media_Type_ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [seasonality_month_media_IDX]
    ON [Forecasting].[Seasonality]([Media_Type_FK] ASC, [Seasonality_Month] ASC);

