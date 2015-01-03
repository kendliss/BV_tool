CREATE TABLE [bvt_prod].[Flight_Plan_Records_Volume] (
    [idFlight_Plan_Records_Volume] INT IDENTITY (1, 1) NOT NULL,
    [idVolume_Status_LU_FK]        INT NOT NULL,
    [Volume]                       INT NULL,
    [idFlight_Plan_Records_FK]     INT NULL,
    PRIMARY KEY CLUSTERED ([idFlight_Plan_Records_Volume] ASC),
    FOREIGN KEY ([idVolume_Status_LU_FK]) REFERENCES [bvt_prod].[Volume_Status_LU] ([idVolume_Status_LU]),
    CONSTRAINT [FK_Flight_Plan_Records_Volume_Flight_Plan_Records_FK] FOREIGN KEY ([idFlight_Plan_Records_FK]) REFERENCES [bvt_prod].[Flight_Plan_Records] ([idFlight_Plan_Records])
);


GO
CREATE NONCLUSTERED INDEX [Flight_Plan_Records_Volume_FKIndex1]
    ON [bvt_prod].[Flight_Plan_Records_Volume]([idVolume_Status_LU_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_106]
    ON [bvt_prod].[Flight_Plan_Records_Volume]([idVolume_Status_LU_FK] ASC);

