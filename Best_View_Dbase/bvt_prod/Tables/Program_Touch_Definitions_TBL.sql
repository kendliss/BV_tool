CREATE TABLE [bvt_prod].[Program_Touch_Definitions_TBL] (
    [idProgram_Touch_Definitions_TBL] INT           IDENTITY (1, 1) NOT NULL,
    [idChanel_LU_TBL_FK]              INT           NOT NULL,
    [idGoal_LU_TBL_FK]                INT           NOT NULL,
    [idCreative_LU_TBL_FK]            INT           NOT NULL,
    [idOffer_LU_TBL_FK]               INT           NOT NULL,
    [idAudience_LU_TBL_FK]            INT           NOT NULL,
    [idTactic_LU_TBL_FK]              INT           NOT NULL,
    [idCampaign_Type_LU_TBL_FK]       INT           NOT NULL,
    [idMedia_LU_TBL_FK]               INT           NOT NULL,
    [owner_type_matrix_id_FK]         INT           NULL,
    [Touch_Name]                      VARCHAR (255) NULL,
    [idProgram_LU_TBL_FK]             INT           NULL,
    PRIMARY KEY CLUSTERED ([idProgram_Touch_Definitions_TBL] ASC),
    FOREIGN KEY ([idAudience_LU_TBL_FK]) REFERENCES [bvt_prod].[Audience_LU_TBL] ([idAudience_LU_TBL]),
    FOREIGN KEY ([idCampaign_Type_LU_TBL_FK]) REFERENCES [bvt_prod].[Campaign_Type_LU_TBL] ([idCampaign_Type_LU_TBL]),
    FOREIGN KEY ([idCreative_LU_TBL_FK]) REFERENCES [bvt_prod].[Creative_LU_TBL] ([idCreative_LU_TBL]),
    FOREIGN KEY ([idGoal_LU_TBL_FK]) REFERENCES [bvt_prod].[Goal_LU_TBL] ([idGoal_LU_TBL]),
    FOREIGN KEY ([idMedia_LU_TBL_FK]) REFERENCES [bvt_prod].[Media_LU_TBL] ([idMedia_LU_TBL]),
    FOREIGN KEY ([idOffer_LU_TBL_FK]) REFERENCES [bvt_prod].[Offer_LU_TBL] ([idOffer_LU_TBL]),
    FOREIGN KEY ([idTactic_LU_TBL_FK]) REFERENCES [bvt_prod].[Tactic_LU_TBL] ([idTactic_LU_TBL]),
    CONSTRAINT [FK_ChannelLU] FOREIGN KEY ([idChanel_LU_TBL_FK]) REFERENCES [bvt_prod].[Channel_LU_TBL] ([idChanel_LU_TBL]),
    CONSTRAINT [FK_ProgramLU_Def] FOREIGN KEY ([idProgram_LU_TBL_FK]) REFERENCES [bvt_prod].[Program_LU_TBL] ([idProgram_LU_TBL])
);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex3]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idMedia_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex4]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idCampaign_Type_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex5]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idTactic_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex6]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idAudience_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex7]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idOffer_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex8]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idCreative_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex9]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idGoal_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [Program_Touch_Definitions_TBL_FKIndex10]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idChanel_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_80]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idMedia_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_81]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idCampaign_Type_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_82]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idTactic_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_83]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idAudience_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_84]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idOffer_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_85]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idCreative_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_86]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idGoal_LU_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_87]
    ON [bvt_prod].[Program_Touch_Definitions_TBL]([idChanel_LU_TBL_FK] ASC);

