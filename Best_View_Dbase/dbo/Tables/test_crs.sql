CREATE TABLE [dbo].[test_crs] (
    [touch_type_fk]      INT          NOT NULL,
    [touch_name]         VARCHAR (10) NOT NULL,
    [touch_name_2]       VARCHAR (65) NULL,
    [audience_type_name] VARCHAR (8)  NOT NULL,
    [media_type]         VARCHAR (8)  NOT NULL,
    [CALL]               FLOAT (53)   NULL,
    [CLICK]              FLOAT (53)   NULL
);

