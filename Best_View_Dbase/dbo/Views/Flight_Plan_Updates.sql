CREATE VIEW dbo.Flight_Plan_Updates
AS
SELECT      Forecasting.Flight_Plan_Records.Flight_Plan_Record_ID, Forecasting.Flight_Plan_Records.InHome_Date, 
                        Forecasting.Flight_Plan_Records.Target_Value, Forecasting.Target_Type.Target_Type_Name, Forecasting.Flight_Plan_Records.Target_Type_FK, 
                        Forecasting.Flight_Plan_Records.Touch_Type_FK, Forecasting.Flight_Plan_Records.Decile_Targeted, 
                        Forecasting.Flight_Plan_Records.Budget_Given, Forecasting.Current_UVAQ_Flightplan.Audience_Type_Name, 
                        Forecasting.Current_UVAQ_Flightplan.Touch_Name, Forecasting.Current_UVAQ_Flightplan.Touch_Name_2, 
                        Forecasting.Current_UVAQ_Flightplan.Media_Type
FROM          Forecasting.Flight_Plan_Records INNER JOIN
                        Forecasting.Current_UVAQ_Flightplan ON 
                        Forecasting.Flight_Plan_Records.Flight_Plan_Record_ID = Forecasting.Current_UVAQ_Flightplan.Flight_Plan_Record_ID INNER JOIN
                        Forecasting.Target_Type ON Forecasting.Flight_Plan_Records.Target_Type_FK = Forecasting.Target_Type.Target_Type_ID

GO
EXECUTE sp_addextendedproperty @name = N'MS_AlternateBackThemeColorIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DatasheetForeThemeColorIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DatasheetGridlinesThemeColorIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


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
         Begin Table = "Flight_Plan_Records (Forecasting)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 200
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Current_UVAQ_Flightplan (Forecasting)"
            Begin Extent = 
               Top = 8
               Left = 409
               Bottom = 246
               Right = 610
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Target_Type (Forecasting)"
            Begin Extent = 
               Top = 250
               Left = 333
               Bottom = 352
               Right = 689
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
         Column = 2115
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = N'((((Media_Type In ("CA","DM"))) And (Audience_Type_Name="LT")) And (Touch_Name="Recurring")) And (Touch_Name_2<>"TV Upsell" Or Touch_Name_2 Is Null)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'[Flight_Plan_Updates].[InHome_Date]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 10000, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ThemeFontIndex', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Flight_Plan_Updates';

