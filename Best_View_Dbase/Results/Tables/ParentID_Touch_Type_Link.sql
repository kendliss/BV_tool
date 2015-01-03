CREATE TABLE [Results].[ParentID_Touch_Type_Link] (
    [ParentID]      NUMERIC (12) NOT NULL,
    [Touch_Type_FK] INT          NOT NULL,
    CONSTRAINT [PK_ParentID_Touch_Type_Link] PRIMARY KEY CLUSTERED ([ParentID] ASC)
);

