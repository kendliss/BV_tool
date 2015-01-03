﻿CREATE TABLE [PulseQC].[CONSUMER_SCAMP_REPORT_a] (
    [CALLDATE]      DATETIME     NOT NULL,
    [CATEGORY]      VARCHAR (50) NOT NULL,
    [DIALBTN]       CHAR (10)    NOT NULL,
    [REGION]        CHAR (2)     NOT NULL,
    [TOTAL]         FLOAT (53)   NOT NULL,
    [BUSINESS_HRS]  FLOAT (53)   NOT NULL,
    [AFTER_HRS]     FLOAT (53)   NOT NULL,
    [REMAINDER_HRS] FLOAT (53)   NOT NULL
);

