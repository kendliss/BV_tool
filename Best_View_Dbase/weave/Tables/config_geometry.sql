CREATE TABLE [weave].[config_geometry] (
    [name]        VARCHAR (256)  NULL,
    [connection]  VARCHAR (256)  NULL,
    [schema]      VARCHAR (256)  NULL,
    [tablePrefix] VARCHAR (256)  NULL,
    [keyType]     VARCHAR (256)  NULL,
    [projection]  VARCHAR (256)  NULL,
    [importNotes] VARCHAR (2048) NULL
);


GO
CREATE NONCLUSTERED INDEX [config_geometry_index]
    ON [weave].[config_geometry]([name] ASC);

