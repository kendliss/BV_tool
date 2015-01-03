CREATE TABLE [CLM].[addr_loc_geo] (
    [addr_loc_src_addr_key_id] BIGINT       NULL,
    [cbsa_cd]                  VARCHAR (10) NULL,
    [cbsa_nm]                  VARCHAR (35) NULL,
    [clli_cd]                  VARCHAR (11) NULL,
    [cntrl_offc_nm]            VARCHAR (35) NULL,
    [dsgnt_mkt_area_cd]        CHAR (5)     NULL,
    [dsgnt_mkt_area_nm]        VARCHAR (35) NULL,
    [dstrb_area_cd]            CHAR (6)     NULL,
    [lata_cd]                  CHAR (5)     NULL,
    [lata_geo_id]              INT          NULL,
    [lata_geo_nm]              VARCHAR (35) NULL,
    [loc_tmzn_cd]              CHAR (5)     NULL,
    [locl_mkt_area_cd]         CHAR (5)     NULL,
    [locl_mkt_area_nm]         VARCHAR (35) NULL,
    [rt_cntr_cd]               CHAR (10)    NULL,
    [rt_cntr_full_nm]          VARCHAR (50) NULL,
    [st_cd]                    CHAR (2)     NULL,
    [video_hub_offc_cd]        CHAR (6)     NULL,
    [wire_cntr_cd]             CHAR (8)     NULL,
    [wirlne_rgn_geo_cd]        CHAR (2)     NULL,
    [load_dt_tm]               DATETIME     NULL,
    [updt_dt_tm]               DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [addr_loc_geo_key_hub_idx]
    ON [CLM].[addr_loc_geo]([addr_loc_src_addr_key_id] ASC, [video_hub_offc_cd] ASC);

