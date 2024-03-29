USE [M4StockManagementSystemDb]
GO
ALTER TABLE [dbo].[tblStockOut] DROP CONSTRAINT [FK_tblStockOut_tblItem]
GO
ALTER TABLE [dbo].[tblStockIn] DROP CONSTRAINT [FK_tblStockIn_tblItem]
GO
ALTER TABLE [dbo].[tblItem] DROP CONSTRAINT [FK_tblItem_tblCompany]
GO
ALTER TABLE [dbo].[tblItem] DROP CONSTRAINT [FK_tblItem_tblCategory]
GO
/****** Object:  Table [dbo].[tblStockOut]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblStockOut]
GO
/****** Object:  Table [dbo].[tblStockIn]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblStockIn]
GO
/****** Object:  Table [dbo].[tblLogInUser]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblLogInUser]
GO
/****** Object:  Table [dbo].[tblItem]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblItem]
GO
/****** Object:  Table [dbo].[tblCompany]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblCompany]
GO
/****** Object:  Table [dbo].[tblCheckBalance]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblCheckBalance]
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 12/24/2017 6:41:51 PM ******/
DROP TABLE [dbo].[tblCategory]
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCategory](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](50) NULL,
	[UserId] [int] NULL,
	[Operation] [varchar](50) NULL,
	[OperationDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_tblCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCheckBalance]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCheckBalance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NULL,
	[TotalStockIn] [int] NULL,
	[TotalStockOut] [int] NULL,
	[BalanceQuantity] [int] NULL,
 CONSTRAINT [PK_tblTempQuantity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCompany]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCompany](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](50) NULL,
	[UserId] [int] NULL,
	[Operation] [varchar](50) NULL,
	[OperationDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_tblCompany] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblItem]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblItem](
	[ItemId] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [varchar](50) NULL,
	[CategoryId] [int] NULL,
	[CompanyId] [int] NULL,
	[ReorderLevel] [int] NULL,
	[UserId] [int] NULL,
	[Operation] [varchar](50) NULL,
	[OperationDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_tblItem] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLogInUser]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLogInUser](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[LogInId] [varchar](50) NULL,
	[LogInPassword] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[UserType] [varchar](50) NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStockIn]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStockIn](
	[InId] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NULL,
	[InDate] [date] NULL,
	[InQuantity] [int] NULL,
	[UserId] [int] NULL,
	[Operation] [varchar](50) NULL,
	[OperationDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_tblStockIn] PRIMARY KEY CLUSTERED 
(
	[InId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStockOut]    Script Date: 12/24/2017 6:41:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStockOut](
	[OutId] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NULL,
	[OutDate] [date] NULL,
	[OutQuantity] [int] NULL,
	[OutType] [varchar](50) NULL,
	[UserId] [int] NULL,
	[Operation] [varchar](50) NULL,
	[OperationDateTime] [smalldatetime] NULL,
 CONSTRAINT [PK_tblStockOut] PRIMARY KEY CLUSTERED 
(
	[OutId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tblCategory] ON 

GO
INSERT [dbo].[tblCategory] ([CategoryId], [CategoryName], [UserId], [Operation], [OperationDateTime]) VALUES (1, N'Stationary', 1, N'EDIT', CAST(0xA85200CA AS SmallDateTime))
GO
INSERT [dbo].[tblCategory] ([CategoryId], [CategoryName], [UserId], [Operation], [OperationDateTime]) VALUES (2, N'Cosmetic', 1, N'EDIT', CAST(0xA85200CA AS SmallDateTime))
GO
INSERT [dbo].[tblCategory] ([CategoryId], [CategoryName], [UserId], [Operation], [OperationDateTime]) VALUES (3, N'Electronic', 1, N'EDIT', CAST(0xA85200C5 AS SmallDateTime))
GO
INSERT [dbo].[tblCategory] ([CategoryId], [CategoryName], [UserId], [Operation], [OperationDateTime]) VALUES (4, N'Kichen Item', 1, N'SAVE', CAST(0xA85200CA AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[tblCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckBalance] ON 

GO
INSERT [dbo].[tblCheckBalance] ([Id], [ItemId], [TotalStockIn], [TotalStockOut], [BalanceQuantity]) VALUES (1, 9, 10, 7, 3)
GO
SET IDENTITY_INSERT [dbo].[tblCheckBalance] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCompany] ON 

GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (1, N'Unilever', 2, N'SAVE', CAST(0xA85200D0 AS SmallDateTime))
GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (2, N'PRAN RFL', 1, N'EDIT', CAST(0xA85200D0 AS SmallDateTime))
GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (3, N'Walton', 2, N'SAVE', CAST(0xA85200D0 AS SmallDateTime))
GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (4, N'Nova', 2, N'SAVE', CAST(0xA85200D0 AS SmallDateTime))
GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (7, N'SINGER', 1, N'SAVE', CAST(0xA85200E8 AS SmallDateTime))
GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (8, N'Symphony', 1, N'SAVE', CAST(0xA85200E9 AS SmallDateTime))
GO
INSERT [dbo].[tblCompany] ([CompanyId], [CompanyName], [UserId], [Operation], [OperationDateTime]) VALUES (9, N'QUALITY', 2, N'SAVE', CAST(0xA8520402 AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[tblCompany] OFF
GO
SET IDENTITY_INSERT [dbo].[tblItem] ON 

GO
INSERT [dbo].[tblItem] ([ItemId], [ItemName], [CategoryId], [CompanyId], [ReorderLevel], [UserId], [Operation], [OperationDateTime]) VALUES (1, N'Lux Soup', 2, 1, 5, 1, N'SAVE', CAST(0xA85200D9 AS SmallDateTime))
GO
INSERT [dbo].[tblItem] ([ItemId], [ItemName], [CategoryId], [CompanyId], [ReorderLevel], [UserId], [Operation], [OperationDateTime]) VALUES (3, N'Iron', 4, 4, 2, 2, N'EDIT', CAST(0xA85200D9 AS SmallDateTime))
GO
INSERT [dbo].[tblItem] ([ItemId], [ItemName], [CategoryId], [CompanyId], [ReorderLevel], [UserId], [Operation], [OperationDateTime]) VALUES (7, N'ICE CREAM', 4, 9, 2, 2, N'SAVE', CAST(0xA8520403 AS SmallDateTime))
GO
INSERT [dbo].[tblItem] ([ItemId], [ItemName], [CategoryId], [CompanyId], [ReorderLevel], [UserId], [Operation], [OperationDateTime]) VALUES (8, N'SUNSILK', 2, 1, 12, 2, N'SAVE', CAST(0xA8520407 AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[tblItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblLogInUser] ON 

GO
INSERT [dbo].[tblLogInUser] ([UserId], [LogInId], [LogInPassword], [UserName], [UserType]) VALUES (1, N'azad', N'123', N'MD. AZADUL ISLAM', N'Admin')
GO
INSERT [dbo].[tblLogInUser] ([UserId], [LogInId], [LogInPassword], [UserName], [UserType]) VALUES (2, N'noor', N'123', N'MD. NOOR UDDIN CHY.', N'Admin')
GO
INSERT [dbo].[tblLogInUser] ([UserId], [LogInId], [LogInPassword], [UserName], [UserType]) VALUES (7, N'jahangir', N'123', N'MD. JAHANGIR ALAM', N'Admin')
GO
INSERT [dbo].[tblLogInUser] ([UserId], [LogInId], [LogInPassword], [UserName], [UserType]) VALUES (8, N'hasib', N'123', N'MD. SALAUDDIN', N'Admin')
GO
SET IDENTITY_INSERT [dbo].[tblLogInUser] OFF
GO
ALTER TABLE [dbo].[tblItem]  WITH CHECK ADD  CONSTRAINT [FK_tblItem_tblCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[tblCategory] ([CategoryId])
GO
ALTER TABLE [dbo].[tblItem] CHECK CONSTRAINT [FK_tblItem_tblCategory]
GO
ALTER TABLE [dbo].[tblItem]  WITH CHECK ADD  CONSTRAINT [FK_tblItem_tblCompany] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[tblCompany] ([CompanyId])
GO
ALTER TABLE [dbo].[tblItem] CHECK CONSTRAINT [FK_tblItem_tblCompany]
GO
ALTER TABLE [dbo].[tblStockIn]  WITH CHECK ADD  CONSTRAINT [FK_tblStockIn_tblItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblStockIn] CHECK CONSTRAINT [FK_tblStockIn_tblItem]
GO
ALTER TABLE [dbo].[tblStockOut]  WITH CHECK ADD  CONSTRAINT [FK_tblStockOut_tblItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblStockOut] CHECK CONSTRAINT [FK_tblStockOut_tblItem]
GO
