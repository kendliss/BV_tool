CREATE TABLE [dbo].[January 2nd Half Call Sales] (
    [CUSTOMER LOCATION IDENTIFIER]        BIGINT        NULL,
    [ACCOUNT IDENTIFIER]                  INT           NULL,
    [U-VERSE ORIGINAL SERVICE DATE]       DATETIME      NULL,
    [IPTV CURRENT PLAN CODE]              VARCHAR (12)  NULL,
    [IPTV BILLING EFFECTIVE DATE]         DATETIME      NULL,
    [SOURCE CREATION DATE]                DATETIME      NULL,
    [ACCOUNT NUMBER]                      INT           NULL,
    [ADDRESS LINE 1 TEXT]                 VARCHAR (255) NULL,
    [ADDRESS LINE 2 TEXT]                 VARCHAR (255) NULL,
    [CITY NAME]                           VARCHAR (75)  NULL,
    [STATE CODE]                          VARCHAR (11)  NULL,
    [((ZIP CODE+'-')+ZIP CODE PLUS)]      INT           NULL,
    [SERVICE ORDER ACTION CODE]           VARCHAR (2)   NULL,
    [SERVICE TYPE CODE]                   VARCHAR (3)   NULL,
    [SERVICE ORDER ACTION REASON TITLE]   VARCHAR (MAX) NULL,
    [SERVICE ORDER ACTION TITLE]          VARCHAR (14)  NULL,
    [ASSOCIATED PROMOTIONAL PROGRAM NAME] VARCHAR (MAX) NULL
);

