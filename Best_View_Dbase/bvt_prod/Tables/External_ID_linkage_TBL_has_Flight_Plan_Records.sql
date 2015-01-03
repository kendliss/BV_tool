CREATE TABLE [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records] (
    [idExternal_ID_linkage_TBL_FK] INT NOT NULL,
    [idFlight_Plan_Records_FK]     INT NOT NULL,
    PRIMARY KEY CLUSTERED ([idExternal_ID_linkage_TBL_FK] ASC, [idFlight_Plan_Records_FK] ASC),
    FOREIGN KEY ([idExternal_ID_linkage_TBL_FK]) REFERENCES [bvt_prod].[External_ID_linkage_TBL] ([idExternal_ID_linkage_TBL]),
    FOREIGN KEY ([idFlight_Plan_Records_FK]) REFERENCES [bvt_prod].[Flight_Plan_Records] ([idFlight_Plan_Records])
);


GO
CREATE NONCLUSTERED INDEX [External_ID_linkage_TBL_has_Flight_Plan_Records_FKIndex1]
    ON [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]([idExternal_ID_linkage_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [External_ID_linkage_TBL_has_Flight_Plan_Records_FKIndex2]
    ON [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]([idFlight_Plan_Records_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_113]
    ON [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]([idExternal_ID_linkage_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_114]
    ON [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records]([idFlight_Plan_Records_FK] ASC);

