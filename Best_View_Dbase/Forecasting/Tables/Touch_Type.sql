CREATE TABLE [Forecasting].[Touch_Type] (
    [Touch_Type_id]    INT          IDENTITY (1, 1) NOT NULL,
    [Media_Type_FK]    INT          NOT NULL,
    [Touch_Name]       VARCHAR (10) NOT NULL,
    [Touch_Name_2]     VARCHAR (65) NULL,
    [Audience_FK]      INT          NOT NULL,
    [Program_Owner_FK] INT          NULL,
    [Agency]           VARCHAR (50) NULL,
    CONSTRAINT [PK__Touch_Type__1CBC4616] PRIMARY KEY CLUSTERED ([Touch_Type_id] ASC),
    CONSTRAINT [FK_Program_Owner_Touch_Type] FOREIGN KEY ([Program_Owner_FK]) REFERENCES [Forecasting].[Program_Owners] ([Program_Owner_ID]) ON DELETE SET NULL,
    CONSTRAINT [FK_Touch_Type_Audience] FOREIGN KEY ([Audience_FK]) REFERENCES [Forecasting].[Audience] ([Audience_ID]),
    CONSTRAINT [FK_Touch_Type_Media_Type] FOREIGN KEY ([Media_Type_FK]) REFERENCES [Forecasting].[Media_Type] ([Media_Type_ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Touch_Type_Agency]
    ON [Forecasting].[Touch_Type]([Media_Type_FK] ASC, [Program_Owner_FK] ASC, [Agency] ASC, [Touch_Name] ASC, [Touch_Name_2] ASC, [Audience_FK] ASC);

