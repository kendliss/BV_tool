USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[Combined_Old_Best_View_VW]    Script Date: 02/22/2016 13:38:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER View [bvt_prod].[Combined_Old_Best_View_VW]

AS Select * from bvt_Prod.UVLB_Best_View_VW
UNION ALL Select * from bvt_prod.VALB_Best_View_VW


GO


