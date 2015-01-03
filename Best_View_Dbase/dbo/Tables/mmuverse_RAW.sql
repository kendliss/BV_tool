CREATE TABLE [dbo].[mmuverse_RAW] (
    [publish_timestamp]  DATETIME      NULL,
    [publisher]          VARCHAR (255) NULL,
    [user_name]          VARCHAR (255) NULL,
    [location]           VARCHAR (255) NULL,
    [user_score]         INT           NULL,
    [followers_count]    INT           NULL,
    [friends_count]      INT           NULL,
    [content_title]      TEXT          NULL,
    [destination_url]    TEXT          NULL,
    [sentiment]          TEXT          NULL,
    [matched_categories] TEXT          NULL,
    [matched_terms]      TEXT          NULL,
    [applied_labels]     TEXT          NULL,
    [content_generator]  TEXT          NULL
);

