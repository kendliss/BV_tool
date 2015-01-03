CREATE TABLE [weave].[nielsen_dma_metadata] (
    [minImportance] FLOAT (53) NULL,
    [maxImportance] FLOAT (53) NULL,
    [xMinBounds]    FLOAT (53) NULL,
    [yMinBounds]    FLOAT (53) NULL,
    [xMaxBounds]    FLOAT (53) NULL,
    [yMaxBounds]    FLOAT (53) NULL,
    [tileID]        BIGINT     NOT NULL,
    [tileData]      IMAGE      NULL,
    PRIMARY KEY CLUSTERED ([tileID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [nielsen_dma_metadata_index]
    ON [weave].[nielsen_dma_metadata]([xMinBounds] ASC, [yMinBounds] ASC, [xMaxBounds] ASC, [yMaxBounds] ASC);

