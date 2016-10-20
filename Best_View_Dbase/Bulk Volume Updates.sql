Select * from bvt_prod.Flight_Plan_Records_Volume a
JOIN UVAQ_STAGING.bvt_staging.BulkUpdates b
on a.idFlight_Plan_Records_FK = b.UniqueID


Begin tran
Update bvt_prod.Flight_Plan_Records_Volume
Set Volume = b.NewValueFloat
from bvt_prod.Flight_Plan_Records_Volume a
JOIN UVAQ_STAGING.bvt_staging.BulkUpdates b
on a.idFlight_Plan_Records_FK = b.UniqueID


Commit tran

Delete UVAQ_STAGING.bvt_staging.BulkUpdates