CREATE TABLE [Results].[Finance_Billings] (
    [RecordID]       INT           IDENTITY (1, 1) NOT NULL,
    [AgencyJobNum]   VARCHAR (255) NULL,
    [Invoice_Number] VARCHAR (255) NULL,
    [VendorName]     VARCHAR (255) NULL,
    [Estimate_Desc]  VARCHAR (255) NULL,
    [Project]        VARCHAR (255) NULL,
    [Tactic_Single]  VARCHAR (255) NULL,
    [Minority_Desc]  VARCHAR (255) NULL,
    [Total]          FLOAT (53)    NULL,
    [inhome_date]    DATETIME      NULL,
    [Bill_Month]     INT           NULL,
    [Bill_Year]      INT           NULL,
    [Fixed_Cost_Ind] CHAR (1)      NULL,
    [Project_Type]   VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([RecordID] ASC)
);

