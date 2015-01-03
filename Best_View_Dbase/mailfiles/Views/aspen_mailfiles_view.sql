create view mailfiles.aspen_mailfiles_view as
 select record_source_FK
 ,mailfileid
 ,campaign_name
 ,replace(right(TFN,12),'-','') as TFN
 ,count(*) as quantity
 from mailfiles.Aspen_Mailfiles
 group by record_source_FK
 ,mailfileid
 ,campaign_name
 ,TFN