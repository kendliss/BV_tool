﻿CREATE FUNCTION [bvt_prod].[Touchdef_FUN]
(
	@prog int
)
RETURNS TABLE
AS
RETURN (SELECT idProgram_Touch_Definitions_TBL
	, Touch_Name, Program_Name, Tactic, Media, Audience
	, Creative_Name, Goal, Offer, Campaign_Type, Channel
	, owner_type_matrix_id_FK, 
	SC.Scorecard_group, Scorecard_program_Channel
from bvt_prod.Program_Touch_Definitions_TBL
	left join bvt_prod.Audience_LU_TBL on idAudience_LU_TBL_FK=idAudience_LU_TBL
	left join bvt_prod.Campaign_Type_LU_TBL on idCampaign_Type_LU_TBL_FK=idCampaign_Type_LU_TBL
	left join bvt_prod.Creative_LU_TBL on idCreative_LU_TBL_fk=idCreative_LU_TBL
	left join bvt_prod.Goal_LU_TBL on idGoal_LU_TBL_fk=idGoal_LU_TBL
	left join bvt_prod.Media_LU_TBL on idMedia_LU_TBL_fk=idMedia_LU_TBL
	left join bvt_prod.Offer_LU_TBL on idOffer_LU_TBL_fk=idOffer_LU_TBL
	left join bvt_prod.Program_LU_TBL on idProgram_LU_TBL_fk=idProgram_LU_TBL
	left join bvt_prod.Tactic_LU_TBL on idTactic_LU_TBL_fk=idTactic_LU_TBL
	left join bvt_prod.Channel_LU_TBL on idChanel_LU_TBL_FK=idChanel_LU_TBL
	left Join (Select Distinct ID, scorecard_group, scorecard_program_channel from JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy) sc on sc.ID =  owner_type_matrix_id_FK
WHERE idProgram_LU_TBL_fk=@PROG
)

