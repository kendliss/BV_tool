CREATE TABLE [Forecasting].[Billing_Rules] (
    [Billing_Rule_ID]   INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]     INT        NOT NULL,
    [Month_Difference]  INT        NOT NULL,
    [Billing_Percent]   FLOAT (53) NOT NULL,
    [Entry_Metadata_FK] INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Billing_Rule_ID] ASC),
    CONSTRAINT [FK_Billing_ENTRY_METADATA] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    CONSTRAINT [FK_Billing_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Billing_Rules]
    ON [Forecasting].[Billing_Rules]([Touch_Type_FK] ASC, [Month_Difference] ASC, [Entry_Metadata_FK] ASC);

