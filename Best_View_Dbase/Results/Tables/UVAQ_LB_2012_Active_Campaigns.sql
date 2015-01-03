CREATE TABLE [Results].[UVAQ_LB_2012_Active_Campaigns] (
    [ParentID]        NUMERIC (12)  NOT NULL,
    [Campaign_Name]   VARCHAR (250) NULL,
    [Start_Date]      DATETIME      NULL,
    [Media_Scorecard] VARCHAR (50)  NULL,
    [Vendor]          VARCHAR (50)  NULL,
    CONSTRAINT [PK_UVAQ_LB_2012_Active_Campaigns] PRIMARY KEY CLUSTERED ([ParentID] ASC)
);

