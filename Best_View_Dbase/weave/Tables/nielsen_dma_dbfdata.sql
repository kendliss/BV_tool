CREATE TABLE [weave].[nielsen_dma_dbfdata] (
    [the_geom_id] BIGINT       IDENTITY (1, 1) NOT NULL,
    [name]        VARCHAR (80) NULL,
    [latitude]    FLOAT (53)   NULL,
    [tvperc]      FLOAT (53)   NULL,
    [dma]         BIGINT       NULL,
    [dma1]        VARCHAR (80) NULL,
    [cableperc]   FLOAT (53)   NULL,
    [adsperc]     FLOAT (53)   NULL,
    [longitude]   FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([the_geom_id] ASC)
);

