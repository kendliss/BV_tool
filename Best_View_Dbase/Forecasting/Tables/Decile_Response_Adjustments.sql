CREATE TABLE [Forecasting].[Decile_Response_Adjustments] (
    [Decile_Adjustment_ID] INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]        INT        NOT NULL,
    [Percent_Target]       FLOAT (53) NOT NULL,
    [Adjustment_Factor]    FLOAT (53) NOT NULL,
    [Entry_Metadata_FK]    INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([Decile_Adjustment_ID] ASC),
    CONSTRAINT [FK_DecileAdj_ENTRY_METADATA] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    CONSTRAINT [FK_DecileAdj_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Decile_Response_Adjustments]
    ON [Forecasting].[Decile_Response_Adjustments]([Touch_Type_FK] ASC, [Percent_Target] ASC, [Entry_Metadata_FK] ASC);

