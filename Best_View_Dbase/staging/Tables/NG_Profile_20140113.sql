﻿CREATE TABLE [staging].[NG_Profile_20140113] (
    [CUSTOMER LOCATION IDENTIFIER]                    INT          NULL,
    [MATCHKEY CD]                                     VARCHAR (43) NULL,
    [WIRELESS SUBSCRIPTION STATUS CODE]               VARCHAR (1)  NULL,
    [CUSTOMER LOCATION ORIGINAL SERVICE DATE]         DATETIME     NULL,
    [DIALUP ORIGINAL SERVICE DATE]                    DATETIME     NULL,
    [DIALUP SUBSCRIPTION STATUS INDICATOR]            VARCHAR (1)  NULL,
    [DIGITAL LIFE INDICATOR]                          VARCHAR (1)  NULL,
    [brdbnd_orgnl_srv_dt]                             VARCHAR (1)  NULL,
    [BROADBAND SUBSCRIPTION STATUS CODE]              VARCHAR (1)  NULL,
    [DISH ORIGINAL SERVICE DATE]                      DATETIME     NULL,
    [DISH SUBSCRIPTION STATUS INDICATOR]              VARCHAR (1)  NULL,
    [DIRECTV ORIGINAL SERVICE DATE]                   DATETIME     NULL,
    [DIRECTV SUBSCRIPTION STATUS CODE]                VARCHAR (1)  NULL,
    [EMPLOYEE CONCESSION INDICATOR]                   VARCHAR (1)  NULL,
    [IPDSLAM HSI SUBSRIPTION STATUS CODE]             VARCHAR (1)  NULL,
    [LONG DISTANCE ORIGINAL SERVICE DATE]             DATETIME     NULL,
    [LONG DISTANCE SUBSCRIPTION STATUS CODE]          VARCHAR (1)  NULL,
    [TELCO BROADBAND DSL INDICATOR]                   VARCHAR (1)  NULL,
    [TELCO DRY LOOP INDICATOR]                        VARCHAR (1)  NULL,
    [TELCO ORIGINAL SERVICE DATE]                     DATETIME     NULL,
    [TELCO SUBSCRIPTION STATUS CODE]                  VARCHAR (1)  NULL,
    [WIRELESS ACTIVE BUSINESS ACCOUNT COUNT]          SMALLINT     NULL,
    [WIRELESS ORIGINAL SERVICE DATE]                  DATETIME     NULL,
    [WIRELESS PREPAID INDICATOR]                      VARCHAR (1)  NULL,
    [WIRELESS POSTPAID INDICATOR]                     VARCHAR (1)  NULL,
    [WRLS Sub Stat Code]                              VARCHAR (1)  NULL,
    [U-VERSE ORIGINAL SERVICE DATE]                   DATETIME     NULL,
    [U-VERSE SUBSCRIPTION STATUS CODE]                VARCHAR (1)  NULL,
    [HSI ACTIVE INDICATOR]                            VARCHAR (1)  NULL,
    [HSI BILLING EFFECTIVE DATE]                      DATETIME     NULL,
    [HSI BILLING END DATE]                            DATETIME     NULL,
    [HSI CURRENT PLAN CODE]                           VARCHAR (13) NULL,
    [HSI PREVIOUS PLAN CODE]                          VARCHAR (9)  NULL,
    [HSI UPGRADE CODE]                                VARCHAR (1)  NULL,
    [IPDSLAM INDICATOR]                               VARCHAR (1)  NULL,
    [IPTV ACTIVE INDICATOR]                           VARCHAR (1)  NULL,
    [IPTV BILLING EFFECTIVE DATE]                     DATETIME     NULL,
    [IPTV BILLING END DATE]                           DATETIME     NULL,
    [IPTV CURRENT PLAN CODE]                          VARCHAR (16) NULL,
    [IPTV HIGH DEFINITION BOLT ON INDICATOR]          VARCHAR (1)  NULL,
    [IPTV MOVIE PACKAGE INDICATOR]                    VARCHAR (1)  NULL,
    [IPTV PREVIOUS PLAN CODE]                         VARCHAR (12) NULL,
    [IPTV SPORT PACKAGE INDICATOR]                    VARCHAR (1)  NULL,
    [IPTV UPGRADE CODE]                               VARCHAR (1)  NULL,
    [NON-DIGITAL VIDEO RECORDER SET TOP BOX QUANTITY] SMALLINT     NULL,
    [SELF INSTALLED INDICATOR]                        VARCHAR (1)  NULL,
    [TOTAL SET TOP BOX QUANTITY]                      SMALLINT     NULL,
    [VOIP ACTIVE INDICATOR]                           VARCHAR (1)  NULL,
    [VOIP BILLING EFFECTIVE DATE]                     DATETIME     NULL,
    [VOIP BILLING END DATE]                           DATETIME     NULL,
    [VOIP CURRENT PLAN CODE]                          VARCHAR (30) NULL,
    [VOIP OFFER EFFECTIVE DATE]                       DATETIME     NULL,
    [VOIP PREVIOUS PLAN CODE]                         VARCHAR (30) NULL,
    [VOIP UPGRADE CODE]                               VARCHAR (1)  NULL,
    [BUSINESS ADDRESS IND]                            VARCHAR (1)  NULL,
    [EDUCATIONAL INSTITUTION IND]                     VARCHAR (1)  NULL,
    [FAMILY_DWELLING_UNIT_TYPE_CD]                    VARCHAR (1)  NULL,
    [MISC_CARD_IND]                                   VARCHAR (1)  NULL,
    [STANDARD_RETAIL_CARD_IND]                        VARCHAR (1)  NULL,
    [STANDARD_SPECIALTY_CARD_IND]                     VARCHAR (1)  NULL,
    [UPSCALE_RETAIL_CARD_IND]                         VARCHAR (1)  NULL,
    [UPSCALE_SPECIALTY_CARD_IND]                      VARCHAR (1)  NULL,
    [BANK_CARD_IND]                                   VARCHAR (1)  NULL,
    [OIL_GAS_CARD_IND]                                VARCHAR (1)  NULL,
    [FINANCE_COMP_CARD_IND]                           VARCHAR (1)  NULL,
    [TRAVEL_CARD_IND]                                 VARCHAR (1)  NULL,
    [DWELLING_TYPE_CD]                                SMALLINT     NULL,
    [RESIDENCE_DUR]                                   SMALLINT     NULL,
    [OCCUPATION_CD]                                   SMALLINT     NULL,
    [AGE_IND]                                         VARCHAR (1)  NULL,
    [HH_AGE_CD]                                       SMALLINT     NULL,
    [HH_COMPOSITION_CD]                               SMALLINT     NULL,
    [NUMBER_OF_ADULTS]                                INT          NULL,
    [CHILD_UNK_GENDER_CD]                             VARCHAR (1)  NULL,
    [CHILD_0_2_PRESENT_CD]                            VARCHAR (50) NULL,
    [CHILD_3_5_PRESENT_CD]                            VARCHAR (50) NULL,
    [CHILD_6_10_PRESENT_CD]                           VARCHAR (50) NULL,
    [CHILD_11_15_PRESENT_CD]                          VARCHAR (50) NULL,
    [CHILD_16_17_PRESENT_CD]                          VARCHAR (50) NULL,
    [NUMBER_OF_CHILDREN]                              INT          NULL,
    [DIRECT_MAIL_RESPONDER_CD]                        VARCHAR (1)  NULL,
    [MARITAL_STATUS_CD]                               SMALLINT     NULL,
    [ESTIMATED_INCOME_RANGE_CD]                       VARCHAR (1)  NULL,
    [HOUSEHOLD_INCOME_ID]                             VARCHAR (1)  NULL,
    [HOMEOWNER_RENTER_CD]                             SMALLINT     NULL,
    [HOME_MARKET_VALUE]                               VARCHAR (1)  NULL,
    [ETHNIC_CD]                                       VARCHAR (3)  NULL,
    [ETHNIC_GROUP_CD]                                 VARCHAR (1)  NULL,
    [NUMBER_OF_CARS]                                  VARCHAR (50) NULL,
    [NUMBER_OF_TRUCKS]                                VARCHAR (50) NULL,
    [EDUCATION_CD]                                    SMALLINT     NULL,
    [VEHICLE_PUR_LEASE_CD]                            VARCHAR (1)  NULL,
    [COLLEGE_STUDENT_IND]                             VARCHAR (50) NULL,
    [AGED_PARENT_IND]                                 VARCHAR (50) NULL,
    [CONSUMER_SEGMENT_CD]                             SMALLINT     NULL,
    [CONSUMER_SEGMENT_LEVEL_CD]                       VARCHAR (1)  NULL,
    [CUSTOMER_PROFILE_SEGMENT_CD]                     SMALLINT     NULL,
    [CUSTOMER_PROFILE_SEG_LEVEL_CD]                   VARCHAR (1)  NULL,
    [RESIDENCE_DUR_BASIS_CD]                          VARCHAR (1)  NULL,
    [NUMBER_OF_ADULTS_BASIS_CD]                       VARCHAR (1)  NULL,
    [MARITAL_STATUS_BASIS_CD]                         VARCHAR (1)  NULL,
    [HOUSEHOLD_INCOME_BASIS_CD]                       VARCHAR (1)  NULL,
    [HOMEOWNER_RENTER_BASIS_CD]                       VARCHAR (1)  NULL,
    [EDUCATION_BASIS_CD]                              VARCHAR (1)  NULL,
    [DWELLING_TYPE_BASIS_CD]                          VARCHAR (1)  NULL,
    [ETECH_ETHNIC_CD]                                 VARCHAR (3)  NULL,
    [ETECH_ETHNIC_GROUP_CD]                           VARCHAR (1)  NULL
);

