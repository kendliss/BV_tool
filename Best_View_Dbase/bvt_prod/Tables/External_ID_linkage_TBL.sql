CREATE TABLE [bvt_prod].[External_ID_linkage_TBL] (
    [idExternal_ID_linkage_TBL] INT          IDENTITY (1, 1) NOT NULL,
    [Source_System]             VARCHAR (45) NULL,
    [Source_System_ID]          VARCHAR (20) NULL,
    [Field_Name]                VARCHAR (45) NULL,
    PRIMARY KEY CLUSTERED ([idExternal_ID_linkage_TBL] ASC)
);

