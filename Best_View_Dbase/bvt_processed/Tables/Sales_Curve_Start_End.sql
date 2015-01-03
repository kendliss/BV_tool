CREATE TABLE [bvt_processed].[Sales_Curve_Start_End] (
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idkpi_type_FK]                      INT        NOT NULL,
    [Week_ID]                            INT        NULL,
    [week_percent]                       FLOAT (53) NOT NULL,
    [Curve_Start_Date]                   DATE       NULL,
    [END_DATE]                           DATETIME   NULL
);

