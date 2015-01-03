CREATE TABLE [bvt_processed].[Response_Daily_Start_End] (
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idkpi_type_FK]                      INT        NOT NULL,
    [Day_of_Week]                        INT        NULL,
    [Day_Percent]                        FLOAT (53) NOT NULL,
    [Daily_Start_Date]                   DATE       NULL,
    [END_DATE]                           DATETIME   NULL
);

