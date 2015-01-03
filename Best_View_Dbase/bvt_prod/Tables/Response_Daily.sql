CREATE TABLE [bvt_prod].[Response_Daily] (
    [idResponse_Daily]                   INT        IDENTITY (1, 1) NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [Day_of_Week]                        INT        NULL,
    [Daily_Start_date]                   DATE       DEFAULT (getdate()) NULL,
    [idkpi_type_FK]                      INT        NOT NULL,
    [Day_Percent]                        FLOAT (53) NOT NULL,
    PRIMARY KEY CLUSTERED ([idResponse_Daily] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    CONSTRAINT [idkpi_type_resp_dailyFK] FOREIGN KEY ([idkpi_type_FK]) REFERENCES [bvt_prod].[KPI_Types] ([idKPI_Types])
);


GO
CREATE NONCLUSTERED INDEX [Response_Daily_FKIndex1]
    ON [bvt_prod].[Response_Daily]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_93]
    ON [bvt_prod].[Response_Daily]([idProgram_Touch_Definitions_TBL_FK] ASC);

