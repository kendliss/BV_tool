CREATE TABLE [Forecasting].[Response_Curves_Daily] (
    [Response_Curve_Daily_ID] INT         IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]           INT         NOT NULL,
    [Response_Channel_FK]     INT         NOT NULL,
    [Curve_Day]               VARCHAR (3) NOT NULL,
    [Curve_Day_ID]            INT         NOT NULL,
    [Day_Percent]             FLOAT (53)  NOT NULL,
    [Entry_Metadata_FK]       INT         NOT NULL,
    PRIMARY KEY CLUSTERED ([Response_Curve_Daily_ID] ASC),
    CONSTRAINT [FK_Response_Cuve_Channel] FOREIGN KEY ([Response_Channel_FK]) REFERENCES [Forecasting].[Response_Channel] ([Response_Channel_ID]),
    CONSTRAINT [FK_Response_Cuve_ENTRY_METADATA] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    CONSTRAINT [FK_Response_Cuve_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id])
);

