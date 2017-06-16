ALTER FUNCTION [bvt_prod].[Flightplan_FUN]
(
	@prog int
)
RETURNS TABLE
AS
RETURN (
SELECT --* 
  idFlight_Plan_Records, idVolume_Type_LU_TBL_FK, idProgram_Touch_Definitions_TBL_FK, Budget_Type_LU_TBL_idBudget_Type_LU_TBL, 
  Campaign_Name, InHome_Date, TFN_ind, URL_ind, idTarget_Rate_Reasons_LU_TBL_FK, Lead_Offer, Strategy_Eligibility, Offer_Test_1, Offer_Test_2, Agency
from 
  bvt_prod.Flight_Plan_Records a
  LEFT JOIN bvt_prod.Strategy_Eligibility_LU_TBL b
  on a.Strategy_Eligibility_LU_TBL_FK = b.idStrategy_Eligibility_LU_TBL
  LEFT JOIN bvt_prod.Lead_Offer_LU_TBL c
  on a.Lead_Offer_LU_TBL_FK = c.idLead_Offer_LU_TBL
  LEFT JOIN bvt_prod.Offer_Test_1_LU_TBL d
  on a.Offer_Test_1_LU_TBL_FK = d.idOffer_Test_1_LU_TBL
  LEFT JOIN bvt_prod.Offer_Test_2_LU_TBL e
  on a.Offer_Test_2_LU_TBL_FK = e.idOffer_Test_2_LU_TBL
  LEFT JOIN bvt_prod.Agency_LU_TBL f
  on a.Agency_LU_TBL = f.idAgency_LU_TBL
  
where 
  idProgram_Touch_Definitions_TBL_FK 
    in (select idProgram_Touch_Definitions_TBL 
	from bvt_prod.Program_Touch_Definitions_TBL
	WHERE idProgram_LU_TBL_FK=@PROG)
-------In Home date limitation to prevent excess calculations on old flight plan records
  and inhome_date>='2016-01-01')

