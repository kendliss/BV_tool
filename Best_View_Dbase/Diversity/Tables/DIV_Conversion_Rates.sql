CREATE TABLE [Diversity].[DIV_Conversion_Rates] (
    [DIV_Conversion_Rates_ID] INT        IDENTITY (1, 1) NOT NULL,
    [DIV_Touch_Type_FK]       INT        NOT NULL,
    [DIV_Product_FK]          INT        NOT NULL,
    [DIV_Response_Channel_FK] INT        NOT NULL,
    [DIV_Conversion_Rate]     FLOAT (53) NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Conversion_Rates_ID] ASC)
);

