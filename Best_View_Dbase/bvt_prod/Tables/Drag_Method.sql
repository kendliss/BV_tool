CREATE TABLE [bvt_prod].[Drag_Method] (
    [idDrag_Method]           INT        IDENTITY (1, 1) NOT NULL,
    [idProgram_LU_TBL_FK]     INT        NOT NULL,
    [idDrag_Method_LU_TBL_FK] INT        NOT NULL,
    [Metric]                  FLOAT (53) NULL,
    [drag_start_date]         DATE       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([idDrag_Method] ASC),
    FOREIGN KEY ([idDrag_Method_LU_TBL_FK]) REFERENCES [bvt_prod].[Drag_Method_LU_TBL] ([idDrag_Method_LU_TBL]),
    FOREIGN KEY ([idDrag_Method_LU_TBL_FK]) REFERENCES [bvt_prod].[Drag_Method_LU_TBL] ([idDrag_Method_LU_TBL]),
    FOREIGN KEY ([idProgram_LU_TBL_FK]) REFERENCES [bvt_prod].[Program_LU_TBL] ([idProgram_LU_TBL]),
    FOREIGN KEY ([idProgram_LU_TBL_FK]) REFERENCES [bvt_prod].[Program_LU_TBL] ([idProgram_LU_TBL])
);

