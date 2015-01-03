-- =============================================
-- Author:		<Brittany>
-- Create date: <3/04/2013>
-- Description:	<Pull scamp calls by tfn and date>
-- =============================================
CREATE PROCEDURE [dbo].[SCAMP_CALLS_BY_DAY]
	@dialbtn char(10), @start_date datetime, @end_date datetime
AS
BEGIN
	SET NOCOUNT ON;
SELECT [DIALBTN]
,calldate
,count([ORIGBTN]) as calls
  FROM [SCAMP].[dbo].[TOTAL_BASE_RESP]
  where calldate between @start_date and @end_date
  and dialbtn in (@dialbtn)
group by [DIALBTN]
,calldate

END