create view CLM.UVCLM_360_IPTV_Customer_View
as select
	A.acct_id,
	B.hsi_actv_ind,
	B.iptv_actv_ind,
	B.voip_actv_ind,
	B.hsi_curr_plan_cd,
	B.iptv_curr_plan_cd,
	B.voip_curr_plan_cd,
	C.wirls_subsrptn_sts_cd,
	case when B.hsi_actv_ind='Y' and B.voip_actv_ind='Y' and C.wirls_subsrptn_sts_cd='Y' then 'quad'
	when B.hsi_actv_ind='Y' and B.voip_actv_ind='N' and C.wirls_subsrptn_sts_cd='Y' then 'triple'
	when B.hsi_actv_ind='N' and B.voip_actv_ind='Y' and C.wirls_subsrptn_sts_cd='Y' then 'triple'
	when B.hsi_actv_ind='Y' and B.voip_actv_ind='Y' and C.wirls_subsrptn_sts_cd='N' then 'triple'
	when B.hsi_actv_ind='N' and B.voip_actv_ind='N' and C.wirls_subsrptn_sts_cd='Y' then 'double'
	when B.hsi_actv_ind='N' and B.voip_actv_ind='Y' and C.wirls_subsrptn_sts_cd='N' then 'double'
	when B.hsi_actv_ind='Y' and B.voip_actv_ind='N' and C.wirls_subsrptn_sts_cd='N' then 'double'
	else 'single'
	end as bundle,
	datediff(day,C.uvrs_orgnl_srv_dt,getdate()) as uvrs_tnre_days,
	B.tot_set_tp_box_qty,
	B.iptv_sprt_pckg_ind,
	B.iptv_movie_pckg_ind,
	D.imdm_mail_solicit_ind,
	tot_rev_two_mo_avg,
	tot_rev_12_mo_avg,
	auto_pmt_ind,
	Connected_community_Ind,
	Multiple_dwelling_cd,
	family_dwelling_unit_type_cd,
	city,
	[state],
	residence_dur,
	occupation_cd,
	hh_age_cd,
	hh_composition_cd,
	number_of_adults,
	number_of_children,
	child_0_2_present_cd,
	child_3_5_present_cd,
	child_6_10_present_cd,
	child_11_15_present_cd,
	child_16_17_present_cd,
	direct_mail_responder_cd,
	estimated_income_range_cd,
	household_income_id,
	homeowner_renter_cd,
	home_market_value,
	ethnic_group_cd,
	number_of_cars,
	number_of_trucks,
	education_cd,
	college_student_ind,
	aged_parent_ind,
	consumer_segment_cd,
	number_of_adults_bs_cd,
	household_income_bs_cd,
	marital_status_bs_cd,
	residence_dur_bs_cd,
	education_bs_cd,
	dwelling_type_bs_cd
FROM
 CLM.imdm_acct_non_wirls as A
	INNER JOIN CLM.acct_uvrs_feat as B
		ON A.acct_id=B.acct_id
	INNER JOIN CLM.imdm_cust_loc as C
		ON A.cust_loc_id=C.cloc
	LEFT JOIN CLM.imdm_acct_non_wirls_excl as D
		ON A.acct_id=D.acct_id
	LEFT JOIN CLM.acct_non_wirls_bill_tot_avg as E
		on a.acct_id=e.acct_id
	LEFT JOIN CLM.imdm_addr_loc as F
		on a.srv_addr_loc_src_addr_key_id=F.addr_loc_src_addr_key_id
	LEFT JOIN CLM.tccc_052_demo_inst_50state as G
		on a.hshld_mthky_cd=g.matchkey_cd
where B.iptv_actv_ind='Y'