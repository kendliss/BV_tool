CREATE TABLE [bvt_prod].[FPR_Manual_CPP]
(
	[IdFPR_Manual_CPP] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY, 
    [idCPP_Category_FK] INT NOT NULL, 
    [Bill_Month] INT NOT NULL, 
    [Bill_Year] INT NOT NULL, 
    [CPP] FLOAT NULL, 
    [idFlight_Plan_Record_FK] INT NOT NULL, 
    CONSTRAINT [FK_FPR_Manual_CPP_CPP_Category] FOREIGN KEY ([idCPP_Category_FK]) REFERENCES [bvt_prod].[CPP_Category]([idCPP_Category]), 
    CONSTRAINT [FK_FPR_Manual_CPP_Flight_Plan_Records] FOREIGN KEY ([idFlight_Plan_Record_FK]) REFERENCES [bvt_prod].[Flight_Plan_Records]([idFlight_Plan_Records])
)
