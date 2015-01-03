CREATE TABLE [Diversity].[DIV_Media_Type] (
    [DIV_Media_Type_id] INT          IDENTITY (1, 1) NOT NULL,
    [DIV_Media_Code]    VARCHAR (10) NOT NULL,
    [Media_Descr]       VARCHAR (30) NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Media_Type_id] ASC)
);

