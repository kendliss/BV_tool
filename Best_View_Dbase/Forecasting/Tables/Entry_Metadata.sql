CREATE TABLE [Forecasting].[Entry_Metadata] (
    [Entry_Metadata_ID] INT          IDENTITY (1, 1) NOT NULL,
    [Entry_Source]      VARCHAR (15) NOT NULL,
    [Entry_Date]        DATETIME     NOT NULL,
    [Entry_Reason]      TEXT         NOT NULL,
    PRIMARY KEY CLUSTERED ([Entry_Metadata_ID] ASC)
);

