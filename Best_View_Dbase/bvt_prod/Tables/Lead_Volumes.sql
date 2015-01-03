CREATE TABLE [bvt_prod].[Lead_Volumes] (
    [idLead_Volumes]                     INT IDENTITY (1, 1) NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT NOT NULL,
    [Media_Year]                         INT NULL,
    [Media_Month]                        INT NULL,
    [Volume]                             INT NULL,
    PRIMARY KEY CLUSTERED ([idLead_Volumes] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);

