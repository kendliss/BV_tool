CREATE TABLE [mailfiles].[Aspen_record_source_FK] (
    [Record_Source_FK] INT           IDENTITY (1, 1) NOT NULL,
    [Record_Source]    VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Record_Source_FK] ASC)
);

