CREATE TABLE [Integration].[expired_tags] (
    [Record_ID]    INT           IDENTITY (1, 1) NOT NULL,
    [vanity]       VARCHAR (MAX) NULL,
    [tag_exp_date] DATETIME      NULL
);


GO
GRANT ALTER
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT CONTROL
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT DELETE
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT INSERT
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT REFERENCES
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT SELECT
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT TAKE OWNERSHIP
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT UPDATE
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];


GO
GRANT VIEW DEFINITION
    ON OBJECT::[Integration].[expired_tags] TO [javelin\dclark]
    AS [JAVELIN\bcausey];

