CREATE TABLE [bvt_processed].[Commitment_Views_Financial] (
    [idCommitment_Views_Financial]       INT           IDENTITY (1, 1) NOT NULL,
    [idFlight_Plan_Records_FK]           INT           NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT           NOT NULL,
    [Campaign_Name]                      VARCHAR (255) NOT NULL,
    [InHome_Date]                        DATE          NOT NULL,
    [idCPP_Category_FK]                  INT           NULL,
    [bill_month]                         INT           NOT NULL,
    [bill_year]                          INT           NOT NULL,
    [budget]                             FLOAT (53)    NOT NULL,
    [CV_Submission]                      VARCHAR (255) NOT NULL,
    [Extract_Date]                       DATE          NOT NULL,
    PRIMARY KEY CLUSTERED ([idCommitment_Views_Financial] ASC),
    FOREIGN KEY ([idFlight_Plan_Records_FK]) REFERENCES [bvt_prod].[Flight_Plan_Records] ([idFlight_Plan_Records]),
    FOREIGN KEY ([idFlight_Plan_Records_FK]) REFERENCES [bvt_prod].[Flight_Plan_Records] ([idFlight_Plan_Records]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);

