CREATE TABLE [bvt_prod].[response_channels] (
    [idresponse_channels] INT           IDENTITY (1, 1) NOT NULL,
    [Response_Channel]    VARCHAR (255) NOT NULL,
    [Channel_Description] TEXT          NULL,
    PRIMARY KEY CLUSTERED ([idresponse_channels] ASC)
);

