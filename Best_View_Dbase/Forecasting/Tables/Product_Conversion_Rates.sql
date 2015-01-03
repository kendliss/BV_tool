CREATE TABLE [Forecasting].[Product_Conversion_Rates] (
    [Product_Conversion_Rate_ID] INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]              INT        NOT NULL,
    [Response_Channel_FK]        INT        NOT NULL,
    [Product_FK]                 INT        NOT NULL,
    [Product_Conversion_Rate]    FLOAT (53) NOT NULL,
    [Entry_Metadata_FK]          INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Product_Conversion_Rate_ID] ASC),
    CONSTRAINT [FK_Product_Conversion_ENTRY_METADATA] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    CONSTRAINT [FK_Product_Conversion_Product] FOREIGN KEY ([Product_FK]) REFERENCES [Forecasting].[Products] ([Product_ID]),
    CONSTRAINT [FK_Product_Conversion_Response_Channel] FOREIGN KEY ([Response_Channel_FK]) REFERENCES [Forecasting].[Response_Channel] ([Response_Channel_ID]),
    CONSTRAINT [FK_Product_Conversion_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id])
);

