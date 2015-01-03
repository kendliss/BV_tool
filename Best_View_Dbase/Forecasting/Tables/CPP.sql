CREATE TABLE [Forecasting].[CPP] (
    [CPP_ID]            INT        IDENTITY (1, 1) NOT NULL,
    [Touch_Type_FK]     INT        NOT NULL,
    [Cost_Per_Piece]    FLOAT (53) NOT NULL,
    [Entry_Metadata_FK] INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([CPP_ID] ASC),
    CONSTRAINT [FK_CPP_ENTRY_METADATA] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]),
    CONSTRAINT [FK_CPP_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CPP]
    ON [Forecasting].[CPP]([Touch_Type_FK] ASC, [Entry_Metadata_FK] ASC);

