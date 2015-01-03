CREATE TABLE [weave].[config_data] (
    [name]               VARCHAR (256)  NULL,
    [keyType]            VARCHAR (256)  NULL,
    [dataType]           VARCHAR (256)  NULL,
    [dataTable]          VARCHAR (256)  NULL,
    [geometryCollection] VARCHAR (256)  NULL,
    [year]               VARCHAR (256)  NULL,
    [min]                VARCHAR (256)  NULL,
    [max]                VARCHAR (256)  NULL,
    [title]              VARCHAR (256)  NULL,
    [number]             VARCHAR (256)  NULL,
    [string]             VARCHAR (256)  NULL,
    [connection]         VARCHAR (256)  NULL,
    [sqlQuery]           VARCHAR (2048) NULL
);


GO
CREATE NONCLUSTERED INDEX [config_data_index]
    ON [weave].[config_data]([name] ASC);

