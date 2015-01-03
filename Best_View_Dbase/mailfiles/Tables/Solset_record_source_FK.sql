CREATE TABLE [mailfiles].[Solset_record_source_FK] (
    [Record_Source_FK] INT           IDENTITY (1, 1) NOT NULL,
    [RS_Details]       VARCHAR (255) NOT NULL,
    PRIMARY KEY CLUSTERED ([Record_Source_FK] ASC)
);

