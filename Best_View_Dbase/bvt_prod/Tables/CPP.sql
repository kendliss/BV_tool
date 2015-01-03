CREATE TABLE [bvt_prod].[CPP] (
    [idCPP]                              INT        IDENTITY (1, 1) NOT NULL,
    [idCPP_Category_FK]                  INT        NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [CPP]                                FLOAT (53) NULL,
    [Minimum_Volume]                     INT        NULL,
    [Maximum_Volume]                     INT        NULL,
    [CPP_Start_Date]                     DATE       DEFAULT (getdate()) NULL,
    [Bill_Timing]                        INT        NULL,
    PRIMARY KEY CLUSTERED ([idCPP] ASC),
    FOREIGN KEY ([idCPP_Category_FK]) REFERENCES [bvt_prod].[CPP_Category] ([idCPP_Category]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);


GO
CREATE NONCLUSTERED INDEX [CPP_FKIndex2]
    ON [bvt_prod].[CPP]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_103]
    ON [bvt_prod].[CPP]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_104]
    ON [bvt_prod].[CPP]([idCPP_Category_FK] ASC);

