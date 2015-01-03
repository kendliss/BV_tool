CREATE TABLE [Forecasting].[Flight_Plan_Records] (
    [Flight_Plan_Record_ID] INT          IDENTITY (1, 1) NOT NULL,
    [Flight_Plan_FK]        INT          NOT NULL,
    [Touch_Type_FK]         INT          NOT NULL,
    [InHome_Date]           DATETIME     NOT NULL,
    [Target_Type_FK]        INT          NOT NULL,
    [Target_Value]          FLOAT (53)   NOT NULL,
    [Decile_Targeted]       FLOAT (53)   NULL,
    [Budget_Given]          FLOAT (53)   NULL,
    [prj450_job_cd]         VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Flight_Plan_Record_ID] ASC),
    CONSTRAINT [FK_Flight_Plan_Flight_Plan_Records] FOREIGN KEY ([Flight_Plan_FK]) REFERENCES [Forecasting].[Flight_Plan] ([Flight_Plan_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Flight_Plan_Records_Target_Type] FOREIGN KEY ([Target_Type_FK]) REFERENCES [Forecasting].[Target_Type] ([Target_Type_ID]),
    CONSTRAINT [FK_Flight_Plan_Records_Touch_Type] FOREIGN KEY ([Touch_Type_FK]) REFERENCES [Forecasting].[Touch_Type] ([Touch_Type_id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Flight_Plan_Records]
    ON [Forecasting].[Flight_Plan_Records]([Flight_Plan_FK] ASC, [Touch_Type_FK] ASC, [InHome_Date] ASC, [Target_Type_FK] ASC);

