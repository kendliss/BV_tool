﻿CREATE TABLE [weekly_ops].[OPS_07_YTD_detaildata] (
    [reportweek_yyyyww]         NUMERIC (11)  NOT NULL,
    [MediaMonth_YYYYMM]         NUMERIC (11)  NULL,
    [Scorecard_tab]             VARCHAR (100) NULL,
    [Scorecard_Program_Channel] VARCHAR (100) NULL,
    [tactic_id]                 INT           NOT NULL,
    [ecrw_project_name]         VARCHAR (250) NULL,
    [unapp_quantity]            FLOAT (53)    NULL,
    [Budget_UnApp]              FLOAT (53)    NULL,
    [calls]                     FLOAT (53)    NULL,
    [clicks]                    FLOAT (53)    NULL,
    [telesales]                 FLOAT (53)    NULL,
    [onlinesales]               FLOAT (53)    NULL,
    [tv_telesales]              FLOAT (53)    NULL,
    [tv_onlinesales]            FLOAT (53)    NULL,
    [cv_calls]                  FLOAT (53)    NULL,
    [cv_clicks]                 FLOAT (53)    NULL,
    [cv_tele_sales]             FLOAT (53)    NULL,
    [cv_on_sales]               FLOAT (53)    NULL,
    [cv_tele_tv]                FLOAT (53)    NULL,
    [cv_on_tv]                  FLOAT (53)    NULL,
    [cv_quantity]               FLOAT (53)    NULL,
    [Goal_ITP_Dir_Calls]        FLOAT (53)    NULL,
    [Goal_ITP_Dir_Clicks]       FLOAT (53)    NULL,
    [BV_ITP_Dir_Calls]          FLOAT (53)    NULL,
    [BV_ITP_Dir_Clicks]         FLOAT (53)    NULL,
    [excludefromscorecard]      VARCHAR (50)  NULL
);

