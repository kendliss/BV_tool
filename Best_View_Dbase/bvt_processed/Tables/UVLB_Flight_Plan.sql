CREATE TABLE [bvt_processed].[UVLB_Flight_Plan] (
    [idFlight_Plan_Records]                   INT           IDENTITY (1, 1) NOT NULL,
    [idVolume_Type_LU_TBL_FK]                 INT           NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK]      INT           NOT NULL,
    [Budget_Type_LU_TBL_idBudget_Type_LU_TBL] INT           NOT NULL,
    [Campaign_Name]                           VARCHAR (255) NULL,
    [InHome_Date]                             DATE          NULL,
    [TFN_ind]                                 BIT           NULL,
    [URL_ind]                                 BIT           NULL,
    [idTarget_Rate_Reasons_LU_TBL_FK]         INT           NULL
);

