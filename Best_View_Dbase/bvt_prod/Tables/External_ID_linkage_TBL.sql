CREATE TABLE [bvt_prod].[External_ID_linkage_TBL] (
    [idExternal_ID_linkage_TBL] INT  IDENTITY (1, 1) NOT NULL,
    [idSource_System_LU_FK]    INT NOT NULL,
    [Source_System_ID]  VARCHAR (20) NOT NULL,
    [idSource_Field_Name_LU_FK]   INT NOT NULL,
    PRIMARY KEY CLUSTERED ([idExternal_ID_linkage_TBL] ASC),
	FOREIGN KEY ([idSource_System_LU_FK]) REFERENCES [bvt_prod].Source_System_LU ([idSource_System_LU]),
	FOREIGN KEY ([idSource_Field_Name_LU_FK]) REFERENCES [bvt_prod].Source_Field_Name_LU ([idSource_Field_Name_LU])
);

