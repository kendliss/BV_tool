CREATE TABLE [mailfiles].[FGS_Dieste_Returns] (
    [freedom_job_number]               VARCHAR (7)   NULL,
    [bmc_scf_truck_code]               VARCHAR (3)   NULL,
    [zip_code]                         VARCHAR (5)   NULL,
    [zip4]                             VARCHAR (4)   NULL,
    [delivery_point_code]              VARCHAR (2)   NULL,
    [postnet_check_digit]              VARCHAR (1)   NULL,
    [line_of_travel]                   VARCHAR (5)   NULL,
    [carrt_code]                       VARCHAR (4)   NULL,
    [unique_sequence_number]           VARCHAR (9)   NULL,
    [lot_number]                       VARCHAR (3)   NULL,
    [pallet_number]                    VARCHAR (6)   NULL,
    [tray_sack_number]                 VARCHAR (9)   NULL,
    [package_number]                   VARCHAR (9)   NULL,
    [qual_sequence_number]             VARCHAR (9)   NULL,
    [tray_package_break_field]         VARCHAR (2)   NULL,
    [zip4_dash]                        VARCHAR (1)   NULL,
    [qual_code]                        VARCHAR (1)   NULL,
    [endorsement_line]                 VARCHAR (30)  NULL,
    [record_type]                      VARCHAR (1)   NULL,
    [samp_seed_indicator]              VARCHAR (1)   NULL,
    [imb_code]                         VARCHAR (31)  NULL,
    [post_md_info]                     VARCHAR (39)  NULL,
    [version]                          VARCHAR (4)   NULL,
    [filler_1]                         VARCHAR (64)  NULL,
    [fullname]                         VARCHAR (50)  NULL,
    [business]                         VARCHAR (50)  NULL,
    [address_secondary]                VARCHAR (50)  NULL,
    [address_primary]                  VARCHAR (50)  NULL,
    [city]                             VARCHAR (50)  NULL,
    [state]                            VARCHAR (2)   NULL,
    [ident]                            VARCHAR (10)  NULL,
    [btn]                              VARCHAR (13)  NULL,
    [leadid]                           VARCHAR (15)  NULL,
    [outputid]                         VARCHAR (10)  NULL,
    [campaignid]                       VARCHAR (9)   NULL,
    [drvversion]                       VARCHAR (4)   NULL,
    [drvregion]                        VARCHAR (2)   NULL,
    [drvmailtype]                      VARCHAR (4)   NULL,
    [invpresortbatch]                  VARCHAR (3)   NULL,
    [drvbaseltrcode]                   VARCHAR (4)   NULL,
    [cta800num1]                       VARCHAR (14)  NULL,
    [cta800num2]                       VARCHAR (14)  NULL,
    [ctaurl1]                          VARCHAR (30)  NULL,
    [ctaurl2]                          VARCHAR (60)  NULL,
    [invformcode]                      VARCHAR (7)   NULL,
    [invenvcode]                       VARCHAR (7)   NULL,
    [invinsert]                        VARCHAR (7)   NULL,
    [drvfootprint]                     VARCHAR (4)   NULL,
    [drvaudience]                      VARCHAR (2)   NULL,
    [drvspeedtier]                     VARCHAR (2)   NULL,
    [drvmessaging]                     VARCHAR (4)   NULL,
    [ctaoffercode]                     VARCHAR (10)  NULL,
    [ctalangline]                      VARCHAR (100) NULL,
    [dmlettercode]                     VARCHAR (10)  NULL,
    [category]                         VARCHAR (4)   NULL,
    [firstname]                        VARCHAR (30)  NULL,
    [middlename]                       VARCHAR (20)  NULL,
    [lastname]                         VARCHAR (30)  NULL,
    [filler_2]                         VARCHAR (67)  NULL,
    [prefix]                           VARCHAR (10)  NULL,
    [suffix]                           VARCHAR (10)  NULL,
    [postal_entry_code]                VARCHAR (11)  NULL,
    [filler_3]                         VARCHAR (1)   NULL,
    [finalist_dwelling_code]           VARCHAR (1)   NULL,
    [filler_4]                         VARCHAR (6)   NULL,
    [list_number]                      VARCHAR (4)   NULL,
    [key_code]                         VARCHAR (10)  NULL,
    [convert_sequence_number]          VARCHAR (8)   NULL,
    [customer_type]                    VARCHAR (2)   NULL,
    [multi_dwelling_unit_indicator]    VARCHAR (1)   NULL,
    [latitude]                         VARCHAR (10)  NULL,
    [longitude]                        VARCHAR (11)  NULL,
    [dpv_hygiene_flag]                 VARCHAR (1)   NULL,
    [acct_foreign_speaking_customer]   VARCHAR (3)   NULL,
    [unique_records_vs_previous]       VARCHAR (4)   NULL,
    [vpgm_dma_2byte_code]              VARCHAR (2)   NULL,
    [bill_sys_geo_id]                  VARCHAR (2)   NULL,
    [filler_5]                         VARCHAR (3)   NULL,
    [cablevision_flag]                 VARCHAR (1)   NULL,
    [voip_flag]                        VARCHAR (1)   NULL,
    [ptb_score]                        VARCHAR (2)   NULL,
    [dtr_score]                        VARCHAR (2)   NULL,
    [region_flag]                      VARCHAR (1)   NULL,
    [service_state]                    VARCHAR (2)   NULL,
    [lead_file_batch_id]               VARCHAR (10)  NULL,
    [acct_model_group_code]            VARCHAR (2)   NULL,
    [speed_ranking_number]             VARCHAR (1)   NULL,
    [dsl_indicator]                    VARCHAR (1)   NULL,
    [event_code]                       VARCHAR (6)   NULL,
    [connexions_indicator]             VARCHAR (2)   NULL,
    [distribution_area]                VARCHAR (6)   NULL,
    [dma_cbsa_code]                    VARCHAR (8)   NULL,
    [offer_code_1_byte]                VARCHAR (1)   NULL,
    [clli]                             VARCHAR (11)  NULL,
    [cust_cd]                          VARCHAR (3)   NULL,
    [campaign_code]                    VARCHAR (10)  NULL,
    [target_date]                      VARCHAR (10)  NULL,
    [list_category]                    VARCHAR (2)   NULL,
    [aging_indicator]                  VARCHAR (18)  NULL,
    [spanish_gm]                       VARCHAR (5)   NULL,
    [test_control]                     VARCHAR (2)   NULL,
    [wireless_indicator]               VARCHAR (1)   NULL,
    [date_of_list_pull]                VARCHAR (8)   NULL,
    [combined_ids]                     VARCHAR (10)  NULL,
    [carrier_route]                    VARCHAR (4)   NULL,
    [lot_code]                         VARCHAR (5)   NULL,
    [lot_order]                        VARCHAR (1)   NULL,
    [living_unit_id_lu_id]             VARCHAR (30)  NULL,
    [cable_competitors]                VARCHAR (29)  NULL,
    [cable_competitors_new]            VARCHAR (22)  NULL,
    [stage_one_group_assignment]       VARCHAR (2)   NULL,
    [chicago_sanfrancisco_flag]        VARCHAR (2)   NULL,
    [offer_code_data_flag_2_bytes]     VARCHAR (2)   NULL,
    [saan]                             VARCHAR (12)  NULL,
    [delivery_point]                   VARCHAR (2)   NULL,
    [delivery_point_check_digit]       VARCHAR (1)   NULL,
    [target_id]                        VARCHAR (11)  NULL,
    [candidate_id]                     VARCHAR (10)  NULL,
    [source_indicator]                 VARCHAR (1)   NULL,
    [credit_status]                    VARCHAR (1)   NULL,
    [pair_bonded]                      VARCHAR (1)   NULL,
    [speed_ranking_number_2]           VARCHAR (1)   NULL,
    [frequency_test_flag]              VARCHAR (2)   NULL,
    [agency_flags]                     VARCHAR (1)   NULL,
    [ineligible_flag]                  VARCHAR (1)   NULL,
    [vpgm_cluster_code]                VARCHAR (4)   NULL,
    [file_date]                        VARCHAR (8)   NULL,
    [green_date]                       VARCHAR (8)   NULL,
    [store_1]                          VARCHAR (6)   NULL,
    [store_2]                          VARCHAR (6)   NULL,
    [store_3]                          VARCHAR (6)   NULL,
    [asian_language_test]              VARCHAR (2)   NULL,
    [acct_foreign_speaking_customer_2] VARCHAR (3)   NULL,
    [dsl_eligible_indicator]           VARCHAR (1)   NULL,
    [spanish_data_flag]                VARCHAR (3)   NULL,
    [filler_6]                         VARCHAR (12)  NULL,
    [cell_code]                        VARCHAR (10)  NULL,
    [cloc]                             VARCHAR (12)  NULL,
    [flag_for_service_address]         VARCHAR (1)   NULL,
    [service_address]                  VARCHAR (58)  NULL,
    [service_city]                     VARCHAR (22)  NULL,
    [service_state_2]                  VARCHAR (2)   NULL,
    [service_zip_code]                 VARCHAR (5)   NULL,
    [telco_indicator]                  VARCHAR (1)   NULL,
    [prchs_chnl_cd]                    VARCHAR (2)   NULL,
    [individual_responsibility_unit]   VARCHAR (3)   NULL,
    [dsl_speed]                        VARCHAR (6)   NULL,
    [hsp_model]                        VARCHAR (2)   NULL,
    [att_customer_tenure_2]            VARCHAR (11)  NULL,
    [telcocust_model]                  VARCHAR (2)   NULL,
    [spanish_offer_code]               VARCHAR (9)   NULL,
    [rtnt_ltr_cd]                      VARCHAR (2)   NULL,
    [cpni_ind]                         VARCHAR (1)   NULL,
    [cloc_lfln_acct_ind]               VARCHAR (1)   NULL,
    [hshld_type_cd]                    VARCHAR (2)   NULL,
    [hm_ownr_cd]                       VARCHAR (1)   NULL,
    [hshld_adlt_qty]                   VARCHAR (1)   NULL,
    [hshldr_age_bs_cd]                 VARCHAR (1)   NULL,
    [hshld_chldn_qty]                  VARCHAR (1)   NULL,
    [chldn_prsnt_cd]                   VARCHAR (1)   NULL,
    [prsnc_of_chldn_age_11_15_cd]      VARCHAR (1)   NULL,
    [prsnc_of_chldn_age_16_17_cd]      VARCHAR (1)   NULL,
    [eldry_prsnc_cd]                   VARCHAR (1)   NULL,
    [gndr_cd]                          VARCHAR (1)   NULL,
    [edctn_cd]                         VARCHAR (1)   NULL,
    [estm_hshld_incme_cd]              VARCHAR (1)   NULL,
    [asmln_cd]                         VARCHAR (1)   NULL,
    [ocptn_cd]                         VARCHAR (2)   NULL,
    [telco_tnre_day_cnt]               VARCHAR (5)   NULL,
    [att_customer_tenure]              VARCHAR (11)  NULL,
    [ent_blng_lang_nm]                 VARCHAR (13)  NULL,
    [ent_acct_lang_cd]                 VARCHAR (2)   NULL,
    [hspnc_coo_cd]                     VARCHAR (2)   NULL,
    [df_cloc_score_3601]               VARCHAR (1)   NULL,
    [df_cloc_decile_1302]              VARCHAR (2)   NULL,
    [lndist_intl_toll_mou_3mth_avg]    VARCHAR (9)   NULL,
    [hsp_indiv_respons_unit]           VARCHAR (3)   NULL,
    [fan]                              VARCHAR (8)   NULL,
    [user_id]                          VARCHAR (5)   NULL,
    [loaded_from]                      VARCHAR (100) NULL
);


GO
GRANT ALTER
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT CONTROL
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT DELETE
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT INSERT
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT REFERENCES
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT SELECT
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT TAKE OWNERSHIP
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT UPDATE
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];


GO
GRANT VIEW DEFINITION
    ON OBJECT::[mailfiles].[FGS_Dieste_Returns] TO [JAVELIN\bcausey]
    AS [JAVELIN\nbrindza];

