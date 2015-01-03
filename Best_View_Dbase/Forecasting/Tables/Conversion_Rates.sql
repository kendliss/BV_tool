CREATE TABLE [Forecasting].[Conversion_Rates] (
    [Conversion_Rates_ID] INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]       INT        NOT NULL,
    [Response_Channel_FK] INT        NOT NULL,
    [Conversion_Rate]     FLOAT (53) NOT NULL,
    [Entry_Metadata_FK]   INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Conversion_Rates_ID] ASC),
    CONSTRAINT [FK_Conversion_Rates_Entry_Metadata] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Conversion_Rates_Response_Channel] FOREIGN KEY ([Response_Channel_FK]) REFERENCES [Forecasting].[Response_Channel] ([Response_Channel_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Conversion_Rates_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Conversion_Rates]
    ON [Forecasting].[Conversion_Rates]([Touch_Type_FK] ASC, [Response_Channel_FK] ASC, [Entry_Metadata_FK] ASC);

