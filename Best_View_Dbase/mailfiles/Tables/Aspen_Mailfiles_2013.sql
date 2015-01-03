﻿CREATE TABLE [mailfiles].[Aspen_Mailfiles_2013] (
    [Record_ID]        INT           IDENTITY (1, 1) NOT NULL,
    [BTN10]            VARCHAR (15)  NULL,
    [Name]             VARCHAR (255) NULL,
    [Address]          VARCHAR (82)  NULL,
    [City]             VARCHAR (40)  NULL,
    [State]            VARCHAR (2)   NULL,
    [Zip]              VARCHAR (5)   NULL,
    [Zip4]             VARCHAR (4)   NULL,
    [TFN]              VARCHAR (15)  NULL,
    [MailfileID]       VARCHAR (4)   NULL,
    [ELUID]            VARCHAR (30)  NULL,
    [VPGM]             VARCHAR (2)   NULL,
    [DMA_CD]           VARCHAR (3)   NULL,
    [Campaign_Name]    VARCHAR (255) NULL,
    [CLOC]             VARCHAR (12)  NULL,
    [PTBScore]         VARCHAR (2)   NULL,
    [DTRScore]         VARCHAR (2)   NULL,
    [DTROffer]         VARCHAR (12)  NULL,
    [Prchs_chnl_cd]    VARCHAR (2)   NULL,
    [Wireless_IND]     VARCHAR (1)   NULL,
    [SDR_CLOC]         VARCHAR (12)  NULL,
    [productset]       VARCHAR (15)  NULL,
    [voipflag]         CHAR (1)      NULL,
    [smartphoneflag]   CHAR (1)      NULL,
    [voiceindicator]   CHAR (1)      NULL,
    [DSLindicator]     CHAR (1)      NULL,
    [Record_Source_FK] INT           NULL
);


GO
CREATE CLUSTERED INDEX [IDX_MailfileID_CLOC]
    ON [mailfiles].[Aspen_Mailfiles_2013]([MailfileID] ASC, [CLOC] ASC);

