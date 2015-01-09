CREATE TABLE [bvt_prod].[Source_System_LU]
(
	[idSource_System_LU] INT IDENTITY (1, 1) NOT NULL, 
    [Source_System] VARCHAR(50) NOT NULL, 
    [Source_System_Description] TEXT NULL, 
    CONSTRAINT [PK_Source_System_LU] PRIMARY KEY ([idSource_System_LU]),

)
