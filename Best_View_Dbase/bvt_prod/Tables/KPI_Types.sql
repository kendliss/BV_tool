CREATE TABLE [bvt_prod].[KPI_Types] (
    [idKPI_Types]     INT           IDENTITY (1, 1) NOT NULL,
    [KPI_Type]        VARCHAR (255) NULL,
    [KPI_description] TEXT          NULL,
    PRIMARY KEY CLUSTERED ([idKPI_Types] ASC)
);

