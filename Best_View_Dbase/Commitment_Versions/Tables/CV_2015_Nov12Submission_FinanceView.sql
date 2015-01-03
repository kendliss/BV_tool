CREATE TABLE [Commitment_Versions].[CV_2015_Nov12Submission_FinanceView] (
    [program]            VARCHAR (8)  NOT NULL,
    [Bill_month]         INT          NULL,
    [Bill_year]          INT          NULL,
    [Bill_Amt]           FLOAT (53)   NULL,
    [Media_Type]         VARCHAR (8)  NULL,
    [touch_type_fk]      INT          NULL,
    [project]            VARCHAR (76) NULL,
    [Audience_Type_Name] VARCHAR (8)  NULL,
    [InHome_Date]        DATETIME     NULL
);

