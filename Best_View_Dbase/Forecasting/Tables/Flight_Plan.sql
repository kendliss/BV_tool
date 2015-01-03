CREATE TABLE [Forecasting].[Flight_Plan] (
    [Flight_Plan_ID]    INT          IDENTITY (1, 1) NOT NULL,
    [Flight_Plan_Name]  VARCHAR (35) NOT NULL,
    [Flight_Plan_Desc]  TEXT         NULL,
    [Program_FK]        INT          NOT NULL,
    [Entry_Metadata_FK] INT          NOT NULL,
    CONSTRAINT [PK__Flight_Plan__18EBB532] PRIMARY KEY CLUSTERED ([Flight_Plan_ID] ASC),
    CONSTRAINT [FK_Flight_Plan_Entry_Metadata] FOREIGN KEY ([Entry_Metadata_FK]) REFERENCES [Forecasting].[Entry_Metadata] ([Entry_Metadata_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Flight_Plan_Program] FOREIGN KEY ([Program_FK]) REFERENCES [Forecasting].[Program] ([Program_ID]) ON DELETE CASCADE
);

