CREATE TABLE [CLM].[iptv_chnl_mp_itm] (
    [chnl_mp_nm]      NVARCHAR (23) NULL,
    [vho_cd]          NVARCHAR (6)  NULL,
    [accs_chnl_nbr]   SMALLINT      NULL,
    [eff_start_dt]    DATETIME      NULL,
    [eff_start_tm]    DATETIME      NULL,
    [eff_end_dt]      DATETIME      NULL,
    [eff_end_tm]      DATETIME      NULL,
    [iptv_pkg_id]     NVARCHAR (36) NULL,
    [eff_start_dt_tm] NVARCHAR (50) NULL,
    [eff_end_dt_tm]   NVARCHAR (50) NULL,
    [iptv_statn_id]   NVARCHAR (36) NULL,
    [ltst_rec_ind]    NVARCHAR (1)  NULL,
    [lst_updt_by]     NVARCHAR (8)  NULL,
    [lst_updt_by_oth] NVARCHAR (3)  NULL,
    [update_dt]       DATETIME      NULL,
    [load_dt]         DATETIME      NULL
);

