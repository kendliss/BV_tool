CREATE TABLE [dbo].[FlightPlan_Load$] (
    [Campaign Name] NVARCHAR (255) NULL,
    [DropDate]      DATETIME       NULL,
    [TFN]           BIT            NOT NULL,
    [URL]           BIT            NOT NULL,
    [Touch_Type]    NVARCHAR (255) NULL,
    [Budget Type]   NVARCHAR (255) NULL,
    [Volume Type]   NVARCHAR (255) NULL,
    [Target Adj]    NVARCHAR (255) NULL,
    [Budget]        FLOAT (53)     NULL,
    [Volume]        FLOAT (53)     NULL
);

