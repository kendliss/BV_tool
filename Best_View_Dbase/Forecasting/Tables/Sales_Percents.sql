CREATE TABLE [Forecasting].[Sales_Percents] (
    [Sales_Percents_ID]      INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]          INT        NOT NULL,
    [Product_FK]             INT        NOT NULL,
    [Call_Percent_of_Sales]  FLOAT (53) NOT NULL,
    [Click_Percent_of_Sales] FLOAT (53) NOT NULL,
    [Entry_Metadata_FK]      INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Sales_Percents_ID] ASC),
    CONSTRAINT [FK_Sales_Percents_Entry_Metadata] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Sales_Percents_Product] FOREIGN KEY ([Product_FK]) REFERENCES [Forecasting].[Products] ([Product_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Sales_Percents_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id]) ON DELETE CASCADE
);

