CREATE TABLE [Diversity].[DIV_Response_Rates] (
    [DIV_Response_Rate_ID]    INT        IDENTITY (1, 1) NOT NULL,
    [DIV_Touch_Type_FK]       INT        NOT NULL,
    [DIV_Response_Channel_FK] INT        NOT NULL,
    [DIV_Response_Rate]       FLOAT (53) NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Response_Rate_ID] ASC)
);

