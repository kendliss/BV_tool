-- =============================================
-- Author:		<Brittany>
-- Create date: <2/27/2013>
-- Description:	<Pull scamp calls by tfn>
-- =============================================
CREATE PROCEDURE [dbo].[SCAMP_CALLS]
	@dialbtn char(10), @start_date datetime, @end_date datetime
AS
BEGIN
	SET NOCOUNT ON;
SELECT [DIALBTN]
--,calldate
,count([ORIGBTN]) as calls
  FROM [SCAMP].[dbo].[TOTAL_BASE_RESP]
  where calldate between @start_date and @end_date
  and dialbtn in (@dialbtn)
group by [DIALBTN]
--,calldate

END
