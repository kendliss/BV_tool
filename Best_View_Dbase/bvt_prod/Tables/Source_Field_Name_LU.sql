CREATE TABLE [bvt_prod].[Source_Field_Name_LU]
(
	[idSource_Field_Name_LU] INT IDENTITY (1, 1) NOT NULL, 
	Field_Name varchar(50) not null,
	Field_Name_Description text,
    CONSTRAINT [PK_Source_Field_Name_LU] PRIMARY KEY ([idSource_Field_Name_LU]), 

)
