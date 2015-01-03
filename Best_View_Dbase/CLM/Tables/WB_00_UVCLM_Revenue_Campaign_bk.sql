CREATE TABLE [CLM].[WB_00_UVCLM_Revenue_Campaign_bk] (
    [ParentID]          FLOAT (53)     NULL,
    [Project_ID]        FLOAT (53)     NULL,
    [eCRW_Project_Name] NVARCHAR (255) NULL,
    [Campaign_Name]     NVARCHAR (255) NULL,
    [Load_date]         DATETIME       NULL,
    [MC_Percent]        FLOAT (53)     NULL,
    [record_ID]         INT            IDENTITY (1, 1) NOT NULL
);

