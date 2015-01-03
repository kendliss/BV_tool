CREATE TABLE [bvt_processed].[KPI_Rate_Start_End] (
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idkpi_types_FK]                     INT        NOT NULL,
    [KPI_Rate]                           FLOAT (53) NOT NULL,
    [Rate_Start_Date]                    DATE       NOT NULL,
    [END_DATE]                           DATETIME   NULL
);

