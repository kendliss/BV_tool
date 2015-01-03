CREATE TABLE [bvt_processed].[Commitment_Views] (
    [id_Commitment_Views_TBL]            INT           IDENTITY (1, 1) NOT NULL,
    [id_Flight_Plan_Records_FK]          INT           NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT           NOT NULL,
    [Campaign_Name]                      VARCHAR (255) NOT NULL,
    [InHome_Date]                        DATE          NOT NULL,
    [Media_Year]                         INT           NOT NULL,
    [Media_Month]                        INT           NOT NULL,
    [Media_Week]                         INT           NOT NULL,
    [KPI_TYPE]                           VARCHAR (255) NULL,
    [Product_Code]                       VARCHAR (255) NULL,
    [Forecast_DayDate]                   DATE          NOT NULL,
    [Forecast]                           FLOAT (53)    NULL,
    [CV_Submission]                      VARCHAR (255) NOT NULL,
    [Extract_Date]                       DATE          NOT NULL,
    PRIMARY KEY CLUSTERED ([id_Commitment_Views_TBL] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);

