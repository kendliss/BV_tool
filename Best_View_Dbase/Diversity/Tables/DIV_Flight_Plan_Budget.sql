CREATE TABLE [Diversity].[DIV_Flight_Plan_Budget] (
    [DIV_Flight_Plan_Budget_ID] INT        IDENTITY (1, 1) NOT NULL,
    [DIV_Touch_Type_FK]         INT        NOT NULL,
    [Drop_Date]                 DATETIME   NOT NULL,
    [Inhome_Date]               DATETIME   NOT NULL,
    [Budget]                    FLOAT (53) NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Flight_Plan_Budget_ID] ASC)
);

