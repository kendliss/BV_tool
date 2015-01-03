CREATE TABLE [CLM].[acct_non_wirls_bill_tot_avg] (
    [acct_id]            BIGINT        NULL,
    [bill_sys_geo_id]    INT           NULL,
    [tot_rev_two_mo_avg] FLOAT (53)    NULL,
    [tot_rev_3_mo_avg]   FLOAT (53)    NULL,
    [tot_rev_4_mo_avg]   FLOAT (53)    NULL,
    [tot_rev_5_mo_avg]   FLOAT (53)    NULL,
    [tot_rev_6_mo_avg]   FLOAT (53)    NULL,
    [tot_rev_9_mo_avg]   FLOAT (53)    NULL,
    [tot_rev_12_mo_avg]  FLOAT (53)    NULL,
    [load_dt]            VARCHAR (MAX) NULL,
    [update_dt]          VARCHAR (MAX) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [bill_tot_avg_acct_id_idx]
    ON [CLM].[acct_non_wirls_bill_tot_avg]([acct_id] ASC);

