CREATE TABLE [bvt_processed].[Sales_Rates_Start_End] (
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idkpi_type_FK]                      INT        NOT NULL,
    [idProduct_LU_TBL_FK]                INT        NOT NULL,
    [Sales_Rate]                         FLOAT (53) NOT NULL,
    [Sales_Rate_Start_Date]              DATE       NULL,
    [END_DATE]                           DATETIME   NULL
);

