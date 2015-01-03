
CREATE VIEW [dbo].[BV_Tool_Touch_Type_Human_View]
AS

SELECT bvt_prod.Program_Touch_Definitions_TBL.idProgram_Touch_Definitions_TBL, 
bvt_prod.Program_LU_TBL.Program_Name, 
bvt_prod.Program_Touch_Definitions_TBL.Touch_Name, 
bvt_prod.Program_Touch_Definitions_TBL.owner_type_matrix_id_FK, 
bvt_prod.Media_LU_TBL.Media, 
bvt_prod.Campaign_Type_LU_TBL.Campaign_Type, 
bvt_prod.Audience_LU_TBL.Audience, 
bvt_prod.Tactic_LU_TBL.Tactic, 
bvt_prod.Channel_LU_TBL.Channel, 
bvt_prod.Goal_LU_TBL.Goal, 
bvt_prod.Creative_LU_TBL.Creative_Name, 
bvt_prod.Offer_LU_TBL.Offer
FROM bvt_prod.Tactic_LU_TBL 
	INNER JOIN 
	(bvt_prod.Program_LU_TBL 
	INNER JOIN 
	((bvt_prod.Media_LU_TBL 
	INNER JOIN 
	(bvt_prod.Goal_LU_TBL 
	INNER JOIN 
	(bvt_prod.Creative_LU_TBL 
	INNER JOIN 
	(bvt_prod.Channel_LU_TBL 
	INNER JOIN 
	(bvt_prod.Campaign_Type_LU_TBL 
	INNER JOIN 
	(bvt_prod.Audience_LU_TBL 
	INNER JOIN 
	bvt_prod.Program_Touch_Definitions_TBL 
	ON bvt_prod.Audience_LU_TBL.idAudience_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idAudience_LU_TBL_FK) 
	ON bvt_prod.Campaign_Type_LU_TBL.idCampaign_Type_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idCampaign_Type_LU_TBL_FK) 
	ON bvt_prod.Channel_LU_TBL.idChanel_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idChanel_LU_TBL_FK) 
	ON bvt_prod.Creative_LU_TBL.idCreative_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idCreative_LU_TBL_FK) 
	ON bvt_prod.Goal_LU_TBL.idGoal_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idGoal_LU_TBL_FK) 
	ON bvt_prod.Media_LU_TBL.idMedia_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idMedia_LU_TBL_FK) 
	INNER JOIN bvt_prod.Offer_LU_TBL 
	ON bvt_prod.Program_Touch_Definitions_TBL.idOffer_LU_TBL_FK = bvt_prod.Offer_LU_TBL.idOffer_LU_TBL) 
	ON bvt_prod.Program_LU_TBL.idProgram_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idProgram_LU_TBL_FK) 
	ON bvt_prod.Tactic_LU_TBL.idTactic_LU_TBL = bvt_prod.Program_Touch_Definitions_TBL.idTactic_LU_TBL_FK;
