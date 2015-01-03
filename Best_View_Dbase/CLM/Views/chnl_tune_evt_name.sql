
create view clm.chnl_tune_evt_name
as select simple_channel_add.*, statn_call_ltr_cd from
	(select * from CLM.chnl_tune_evt_mnthly_summary 
		left join CLM.accs_chnl_es_lkup
		ON accs_chnl_nbr=channel) as simple_channel_add
		
		left join 
		
		
	(select acct_id, accs_chnl_nbr, statn_call_ltr_cd 
		from CLM.iptv_chnl_mp_itm, CLM.iptv_statn, CLM.addr_loc_geo, CLM.imdm_acct_non_wirls where 
			iptv_chnl_mp_itm.iptv_statn_id=iptv_statn.iptv_statn_id 
			and iptv_chnl_mp_itm.vho_cd=addr_loc_geo.video_hub_offc_cd
			and addr_loc_geo.addr_loc_src_addr_key_id=imdm_acct_non_wirls.srv_addr_loc_src_addr_key_id
			group by acct_id, accs_chnl_nbr, statn_call_ltr_cd) as call_letter_query
			
	on simple_channel_add.acct_id=call_letter_query.acct_id and simple_channel_add.accs_chnl_nbr=call_letter_query.accs_chnl_nbr
			
