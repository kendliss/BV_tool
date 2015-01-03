CREATE TABLE [Diversity].[DIV_Response_Curves] (
    [DIV_Response_Curve_ID]   INT        IDENTITY (1, 1) NOT NULL,
    [DIV_Touch_Type_FK]       INT        NOT NULL,
    [DIV_Response_Channel_FK] INT        NOT NULL,
    [DIV_Curve_Week]          INT        NOT NULL,
    [DIV_Week_Percent]        FLOAT (53) NOT NULL,
    PRIMARY KEY CLUSTERED ([DIV_Response_Curve_ID] ASC)
);

