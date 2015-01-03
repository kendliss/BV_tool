


CREATE  trigger [capture_ddl] on DATABASE after DDL_DATABASE_LEVEL_EVENTS
as
begin 
SET ARITHABORT ON
DECLARE @data XML
SET @data = EVENTDATA()
SET NOCOUNT on
insert into ddl_log (db_user,db_login,ddl_event_type,dt,ddl_text) values 
(
 CONVERT(varchar(100), CURRENT_USER)
,CONVERT(varchar(100), ORIGINAL_LOGIN())
,@data.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(100)')
,getdate()
,@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'varchar(max)')
)
end



