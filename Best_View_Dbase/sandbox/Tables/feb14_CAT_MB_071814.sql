﻿CREATE TABLE [sandbox].[feb14_CAT_MB_071814] (
    [first_name]                VARCHAR (20) NULL,
    [last_name]                 VARCHAR (20) NULL,
    [prefix]                    VARCHAR (1)  NULL,
    [suffix]                    VARCHAR (1)  NULL,
    [address_1]                 VARCHAR (30) NULL,
    [address_2]                 VARCHAR (30) NULL,
    [city]                      VARCHAR (20) NULL,
    [state]                     VARCHAR (2)  NULL,
    [zip]                       VARCHAR (5)  NULL,
    [zip4]                      VARCHAR (4)  NULL,
    [priorityCD]                VARCHAR (10) NULL,
    [dwellingCD]                VARCHAR (1)  NULL,
    [List_No]                   VARCHAR (4)  NULL,
    [Key_Code]                  VARCHAR (10) NULL,
    [convert_sqncNo]            VARCHAR (8)  NULL,
    [ATT_NATT]                  VARCHAR (2)  NULL,
    [MDU]                       VARCHAR (1)  NULL,
    [lattitude]                 VARCHAR (10) NULL,
    [longitude]                 VARCHAR (11) NULL,
    [DPV_hygeine_flag]          VARCHAR (1)  NULL,
    [foreign_speaker]           VARCHAR (3)  NULL,
    [unique_vs_prev]            VARCHAR (4)  NULL,
    [DMACD]                     VARCHAR (2)  NULL,
    [bill_sys_geo_id]           VARCHAR (2)  NULL,
    [CableVision_flag]          VARCHAR (1)  NULL,
    [voipflag]                  VARCHAR (1)  NULL,
    [PTBScore]                  VARCHAR (2)  NULL,
    [PTWScore]                  VARCHAR (2)  NULL,
    [region]                    VARCHAR (1)  NULL,
    [service_state]             VARCHAR (2)  NULL,
    [Lead_file_batch_id]        VARCHAR (10) NULL,
    [acct_model_grp]            VARCHAR (2)  NULL,
    [DSLindicator]              VARCHAR (1)  NULL,
    [lead_id]                   VARCHAR (15) NULL,
    [eventCD]                   VARCHAR (6)  NULL,
    [connexions_ind]            VARCHAR (2)  NULL,
    [distribution_area]         VARCHAR (6)  NULL,
    [DMA_CBSA_CD]               VARCHAR (8)  NULL,
    [connexions_flag]           VARCHAR (1)  NULL,
    [CLLI]                      VARCHAR (11) NULL,
    [BTN]                       VARCHAR (10) NULL,
    [CUST_CD]                   VARCHAR (3)  NULL,
    [Campaign_Code]             VARCHAR (10) NULL,
    [Target_date]               VARCHAR (10) NULL,
    [List_category]             VARCHAR (2)  NULL,
    [Aging]                     VARCHAR (18) NULL,
    [Spanish_GM]                VARCHAR (5)  NULL,
    [Test_Control]              VARCHAR (1)  NULL,
    [Telco_Ind]                 VARCHAR (1)  NULL,
    [Wireless_IND]              VARCHAR (1)  NULL,
    [date_of_list_pull]         VARCHAR (8)  NULL,
    [ATTlistID_Dmltrcd_ldflbch] VARCHAR (10) NULL,
    [carrier_route]             VARCHAR (4)  NULL,
    [ELUID]                     VARCHAR (30) NULL,
    [cbl_comp]                  VARCHAR (29) NULL,
    [cbl_comp2]                 VARCHAR (22) NULL,
    [DPBC]                      VARCHAR (2)  NULL,
    [DPBC_ckdigit]              VARCHAR (1)  NULL,
    [target_ID]                 VARCHAR (11) NULL,
    [candidate_ID]              VARCHAR (10) NULL,
    [Equifax_flag]              VARCHAR (1)  NULL,
    [Credit_status]             VARCHAR (1)  NULL,
    [DPV_dropped_records]       VARCHAR (1)  NULL,
    [Agency_flag]               VARCHAR (1)  NULL,
    [Map_info_for_Store_1]      VARCHAR (1)  NULL,
    [File_date]                 VARCHAR (8)  NULL,
    [Green_date]                VARCHAR (8)  NULL,
    [Cell_Code]                 VARCHAR (10) NULL,
    [BookID]                    VARCHAR (2)  NULL,
    [User_defined_flags]        VARCHAR (1)  NULL,
    [Store_1]                   VARCHAR (6)  NULL,
    [Store_2]                   VARCHAR (6)  NULL,
    [Store_3]                   VARCHAR (6)  NULL,
    [Distance]                  VARCHAR (2)  NULL,
    [CLOC]                      VARCHAR (12) NULL,
    [SDR_CLOC]                  BIGINT       NULL,
    [Smartkey]                  VARCHAR (12) NULL,
    [TFN]                       VARCHAR (10) NULL,
    [Sequence_removal]          VARCHAR (6)  NULL,
    [Matched]                   VARCHAR (1)  NOT NULL,
    [Calls]                     INT          NULL
);

