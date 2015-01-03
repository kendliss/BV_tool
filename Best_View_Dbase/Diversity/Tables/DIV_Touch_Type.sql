CREATE TABLE [Diversity].[DIV_Touch_Type] (
    [DIV_Touch_Type_id] INT          IDENTITY (1, 1) NOT NULL,
    [DIV_Sub_Type]      VARCHAR (10) NOT NULL,
    [Media_Type]        INT          NOT NULL,
    [Touch_Name]        VARCHAR (50) NOT NULL,
    [Touch_Name_2]      VARCHAR (10) NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Touch_Type_id] ASC)
);

