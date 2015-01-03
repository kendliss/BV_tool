CREATE TABLE [Diversity].[DIV_Flight_Plan_Vol] (
    [DIV_Flight_Plan_VOL_ID] INT          IDENTITY (1, 1) NOT NULL,
    [DIV_Touch_Type_FK]      INT          NOT NULL,
    [Target]                 VARCHAR (10) NOT NULL,
    [Drop_Date]              DATETIME     NOT NULL,
    [Inhome_Date]            DATETIME     NOT NULL,
    [Volume]                 FLOAT (53)   NOT NULL,
    [Project_Budget]         FLOAT (53)   NOT NULL,
    [Finance_Budget]         FLOAT (53)   NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Flight_Plan_VOL_ID] ASC)
);

