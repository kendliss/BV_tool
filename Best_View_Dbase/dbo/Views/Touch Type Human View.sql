CREATE VIEW dbo.[Touch Type Human View]
AS
SELECT      Forecasting.Media_Type.Media_Type, Forecasting.Touch_Type.Touch_Name, Forecasting.Touch_Type.Touch_Name_2, 
                        Forecasting.Audience.Audience_Type_Name, Forecasting.Touch_Type.Touch_Type_id, Forecasting.Program_Owners.Program_Owner
FROM          Forecasting.Touch_Type INNER JOIN
                        Forecasting.Media_Type ON Forecasting.Touch_Type.Media_Type_FK = Forecasting.Media_Type.Media_Type_ID INNER JOIN
                        Forecasting.Audience ON Forecasting.Touch_Type.Audience_FK = Forecasting.Audience.Audience_ID INNER JOIN
                        Forecasting.Program_Owners ON Forecasting.Touch_Type.Program_Owner_FK = Forecasting.Program_Owners.Program_Owner_ID

GO
EXECUTE sp_addextendedproperty @name = N'MS_AlternateBackThemeColorIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DatasheetForeThemeColorIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DatasheetGridlinesThemeColorIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[75] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Touch_Type (Forecasting)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 140
               Right = 202
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Media_Type (Forecasting)"
            Begin Extent = 
               Top = 6
               Left = 240
               Bottom = 108
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Audience (Forecasting)"
            Begin Extent = 
               Top = 174
               Left = 279
               Bottom = 276
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Program_Owners (Forecasting)"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 93
               Right = 640
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ThemeFontIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Touch Type Human View';

