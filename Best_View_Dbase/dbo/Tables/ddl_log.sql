CREATE TABLE [dbo].[ddl_log] (
    [id]             INT           IDENTITY (1, 1) NOT NULL,
    [db_user]        VARCHAR (100) NULL,
    [db_login]       VARCHAR (100) NULL,
    [ddl_event_type] VARCHAR (255) NULL,
    [dt]             DATETIME      NULL,
    [ddl_text]       TEXT          NULL
);

