USE [M4StockManagementSystemDb]
GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockOutView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockOutView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockOutView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockInView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockInView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockInView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ItemView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ItemView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CheckBalanceView'

GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CheckBalanceView'

GO
/****** Object:  View [dbo].[StockOutView]    Script Date: 12/24/2017 6:43:04 PM ******/
DROP VIEW [dbo].[StockOutView]
GO
/****** Object:  View [dbo].[StockInView]    Script Date: 12/24/2017 6:43:04 PM ******/
DROP VIEW [dbo].[StockInView]
GO
/****** Object:  View [dbo].[ItemView]    Script Date: 12/24/2017 6:43:04 PM ******/
DROP VIEW [dbo].[ItemView]
GO
/****** Object:  View [dbo].[CheckBalanceView]    Script Date: 12/24/2017 6:43:04 PM ******/
DROP VIEW [dbo].[CheckBalanceView]
GO
/****** Object:  View [dbo].[CheckBalanceView]    Script Date: 12/24/2017 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CheckBalanceView]
AS
SELECT        dbo.tblCheckBalance.Id, dbo.tblCheckBalance.ItemId, dbo.tblCheckBalance.TotalStockIn, dbo.tblCheckBalance.TotalStockOut, dbo.tblCheckBalance.BalanceQuantity, dbo.tblItem.ItemName, dbo.tblItem.CategoryId, 
                         dbo.tblItem.CompanyId, dbo.tblItem.ReorderLevel, dbo.tblCategory.CategoryName, dbo.tblCompany.CompanyName
FROM            dbo.tblCheckBalance INNER JOIN
                         dbo.tblItem ON dbo.tblCheckBalance.ItemId = dbo.tblItem.ItemId INNER JOIN
                         dbo.tblCategory ON dbo.tblItem.CategoryId = dbo.tblCategory.CategoryId INNER JOIN
                         dbo.tblCompany ON dbo.tblItem.CompanyId = dbo.tblCompany.CompanyId

GO
/****** Object:  View [dbo].[ItemView]    Script Date: 12/24/2017 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ItemView]
AS
SELECT        dbo.tblItem.ItemId, dbo.tblItem.ItemName, dbo.tblItem.CategoryId, dbo.tblItem.CompanyId, dbo.tblItem.ReorderLevel, dbo.tblCompany.CompanyName, dbo.tblCategory.CategoryName, dbo.tblItem.UserId, 
                         dbo.tblItem.Operation, dbo.tblItem.OperationDateTime, dbo.tblLogInUser.LogInId, dbo.tblLogInUser.UserName, dbo.tblLogInUser.UserType
FROM            dbo.tblCategory INNER JOIN
                         dbo.tblItem ON dbo.tblCategory.CategoryId = dbo.tblItem.CategoryId INNER JOIN
                         dbo.tblCompany ON dbo.tblItem.CompanyId = dbo.tblCompany.CompanyId LEFT OUTER JOIN
                         dbo.tblLogInUser ON dbo.tblItem.UserId = dbo.tblLogInUser.UserId

GO
/****** Object:  View [dbo].[StockInView]    Script Date: 12/24/2017 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StockInView]
AS
SELECT        dbo.tblStockIn.InId, dbo.tblStockIn.ItemId, dbo.tblStockIn.InDate, dbo.tblStockIn.InQuantity, dbo.tblStockIn.UserId, dbo.tblStockIn.Operation, dbo.tblStockIn.OperationDateTime, dbo.tblItem.ItemName, 
                         dbo.tblItem.CategoryId, dbo.tblItem.CompanyId, dbo.tblItem.ReorderLevel, dbo.tblCategory.CategoryName, dbo.tblCompany.CompanyName, dbo.tblLogInUser.LogInId, dbo.tblLogInUser.UserName, 
                         dbo.tblLogInUser.UserType
FROM            dbo.tblStockIn INNER JOIN
                         dbo.tblItem ON dbo.tblStockIn.ItemId = dbo.tblItem.ItemId INNER JOIN
                         dbo.tblCompany ON dbo.tblItem.CompanyId = dbo.tblCompany.CompanyId INNER JOIN
                         dbo.tblCategory ON dbo.tblItem.CategoryId = dbo.tblCategory.CategoryId LEFT OUTER JOIN
                         dbo.tblLogInUser ON dbo.tblStockIn.UserId = dbo.tblLogInUser.UserId

GO
/****** Object:  View [dbo].[StockOutView]    Script Date: 12/24/2017 6:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StockOutView]
AS
SELECT        dbo.tblStockOut.OutId, dbo.tblStockOut.ItemId, dbo.tblStockOut.OutDate, dbo.tblStockOut.OutQuantity, dbo.tblStockOut.OutType, dbo.tblStockOut.UserId, dbo.tblStockOut.Operation, 
                         dbo.tblStockOut.OperationDateTime, dbo.tblItem.ItemName, dbo.tblItem.CategoryId, dbo.tblItem.CompanyId, dbo.tblItem.ReorderLevel, dbo.tblCompany.CompanyName, dbo.tblLogInUser.LogInId, 
                         dbo.tblLogInUser.LogInPassword, dbo.tblLogInUser.UserName, dbo.tblLogInUser.UserType, dbo.tblCategory.CategoryName
FROM            dbo.tblCategory INNER JOIN
                         dbo.tblItem ON dbo.tblCategory.CategoryId = dbo.tblItem.CategoryId INNER JOIN
                         dbo.tblCompany ON dbo.tblItem.CompanyId = dbo.tblCompany.CompanyId INNER JOIN
                         dbo.tblStockOut ON dbo.tblItem.ItemId = dbo.tblStockOut.ItemId LEFT OUTER JOIN
                         dbo.tblLogInUser ON dbo.tblStockOut.UserId = dbo.tblLogInUser.UserId

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[58] 4[3] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCheckBalance"
            Begin Extent = 
               Top = 60
               Left = 16
               Bottom = 221
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblItem"
            Begin Extent = 
               Top = 68
               Left = 240
               Bottom = 271
               Right = 433
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCategory"
            Begin Extent = 
               Top = 2
               Left = 497
               Bottom = 154
               Right = 690
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCompany"
            Begin Extent = 
               Top = 161
               Left = 504
               Bottom = 323
               Right = 697
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CheckBalanceView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CheckBalanceView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[58] 4[3] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCategory"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 176
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblItem"
            Begin Extent = 
               Top = 11
               Left = 305
               Bottom = 223
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCompany"
            Begin Extent = 
               Top = 17
               Left = 629
               Bottom = 198
               Right = 802
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblLogInUser"
            Begin Extent = 
               Top = 218
               Left = 637
               Bottom = 380
               Right = 807
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ItemView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ItemView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[63] 4[4] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblStockIn"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 193
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblItem"
            Begin Extent = 
               Top = 18
               Left = 279
               Bottom = 238
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCompany"
            Begin Extent = 
               Top = 162
               Left = 541
               Bottom = 334
               Right = 734
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCategory"
            Begin Extent = 
               Top = 3
               Left = 546
               Bottom = 152
               Right = 739
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblLogInUser"
            Begin Extent = 
               Top = 274
               Left = 264
               Bottom = 423
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
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
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockInView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockInView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockInView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[70] 4[4] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCategory"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 166
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblItem"
            Begin Extent = 
               Top = 9
               Left = 305
               Bottom = 208
               Right = 498
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCompany"
            Begin Extent = 
               Top = 216
               Left = 580
               Bottom = 381
               Right = 773
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblStockOut"
            Begin Extent = 
               Top = 3
               Left = 579
               Bottom = 208
               Right = 772
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblLogInUser"
            Begin Extent = 
               Top = 87
               Left = 913
               Bottom = 246
               Right = 1083
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
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
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockOutView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockOutView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StockOutView'
GO
