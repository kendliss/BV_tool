CREATE TABLE [bvt_processed].[CPP_Start_End] (
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idCPP_Category_FK]                  INT        NOT NULL,
    [CPP]                                FLOAT (53) NULL,
    [Minimum_volume]                     INT        NULL,
    [Maximum_Volume]                     INT        NULL,
    [Bill_timing]                        INT        NULL,
    [CPP_Start_Date]                     DATE       NULL,
    [END_DATE]                           DATETIME   NULL
);

