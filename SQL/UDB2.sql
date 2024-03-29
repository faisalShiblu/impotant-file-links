USE [master]
GO
/****** Object:  Database [UniversityDB]    Script Date: 11/26/2016 1:47:05 PM ******/
CREATE DATABASE [UniversityDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UniversityDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\UniversityDB.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'UniversityDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\UniversityDB_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [UniversityDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [UniversityDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [UniversityDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [UniversityDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [UniversityDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [UniversityDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [UniversityDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [UniversityDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [UniversityDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [UniversityDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [UniversityDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [UniversityDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [UniversityDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [UniversityDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [UniversityDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [UniversityDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [UniversityDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [UniversityDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [UniversityDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [UniversityDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [UniversityDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [UniversityDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [UniversityDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [UniversityDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [UniversityDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [UniversityDB] SET RECOVERY FULL 
GO
ALTER DATABASE [UniversityDB] SET  MULTI_USER 
GO
ALTER DATABASE [UniversityDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [UniversityDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [UniversityDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [UniversityDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'UniversityDB', N'ON'
GO
USE [UniversityDB]
GO
/****** Object:  User [test2]    Script Date: 11/26/2016 1:47:05 PM ******/
CREATE USER [test2] FOR LOGIN [test2] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [test2]
GO
/****** Object:  StoredProcedure [dbo].[SpCourseStatics]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpCourseStatics]
@DepID int
AS
BEGIN
SELECT        dbo.Course.CourseCode, dbo.Course.CourseName, ISNULL(dbo.Teacher.TeacherName, 'Not-assigned yet') AS AssignedTo, dbo.SemesterInfo.SemesterName, 
                         dbo.Course.DepId
FROM            dbo.SemesterInfo RIGHT OUTER JOIN
                         dbo.Course ON dbo.SemesterInfo.Id = dbo.Course.SemId LEFT OUTER JOIN
                         dbo.Teacher RIGHT OUTER JOIN
                         dbo.CourseAssignToTeacher ON dbo.Teacher.Id = dbo.CourseAssignToTeacher.TeacherId ON dbo.Course.Id = dbo.CourseAssignToTeacher.CourseId
						 WHERE Course.DepId=@DepID
END

GO
/****** Object:  UserDefinedFunction [dbo].[IsValidEmail]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsValidEmail](@EMAIL varchar(255))
RETURNS bit as
BEGIN     
  DECLARE @bitRetVal as Bit
  IF (@EMAIL <> '' AND @EMAIL NOT LIKE '_%@__%.__%')
     SET @bitRetVal = 0  -- Invalid
  ELSE 
    SET @bitRetVal = 1   -- Valid
  RETURN @bitRetVal
END 


GO
/****** Object:  UserDefinedFunction [dbo].[StudentRegNo]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[StudentRegNo]
(
@Depcode nvarchar(10),
@year nvarchar(10)
)
RETURNS nvarchar(20)
AS
BEGIN
 DECLARE @RegNo nvarchar(20);  
 DECLARE @latOption nvarchar(20);  
 DECLARE @latOptionInt int;  
	 SELECT @latOption = IsNull(MAX(SUBSTRING(RegNumber,len(@Depcode + '-' + @year + '-')+1,99)),'000') From RegisterStudent where RegNumber like @Depcode+'-' + @year + '-%'
	SET @latOptionInt = CONVERT(int,@latOption) + 1
	if(Len(@latOptionInt)=1)
	BEGIN
        SET @latOption = '00'+ CONVERT(nvarchar(20), @latOptionInt)
    END
	
	if(Len(@latOptionInt)=2)
	BEGIN
        SET @latOption = '0'+ CONVERT(nvarchar(20), @latOptionInt)
    END

	if(Len(@latOptionInt)=3)
	BEGIN
        SET @latOption = CONVERT(nvarchar(20), @latOptionInt)
    END

	SET @RegNo = (@Depcode + '-' + @year + '-' + @latOption)
RETURN @RegNo 
END

GO
/****** Object:  UserDefinedFunction [dbo].[ValidEmailFunc]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ValidEmailFunc]
(
    @Temp nvarchar(255)
)   
--Returns true if the string is a valid email address.  
RETURNS nvarchar(255) 
As  
BEGIN
   Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z,0-9,@,.,-]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')
    Return @Temp
END




--CREATE FUNCTION [dbo].[fnIsValidEmail]
--(
--    @email varchar(255)
--)   
----Returns true if the string is a valid email address.  
--RETURNS bit  
--As  
--BEGIN
--    RETURN CASE WHEN ISNULL(@email, '') <> '' AND @email LIKE '%_@%_.__%' THEN 1 ELSE 0 END
--END




--CREATE FUNCTION [dbo].[fnAppEmailCheck](@email VARCHAR(255))   
----Returns true if the string is a valid email address.  
--RETURNS bit  
--as  
--BEGIN  
--     DECLARE @valid bit  
--     IF @email IS NOT NULL   
--          SET @email = LOWER(@email)  
--          SET @valid = 0  
--          IF @email like '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%'  
--             AND LEN(@email) = LEN(dbo.fnAppStripNonEmail(@email))  
--             AND @email NOT like '%@%@%'  
--             AND CHARINDEX('.@',@email) = 0  
--             AND CHARINDEX('..',@email) = 0  
--             AND CHARINDEX(',',@email) = 0  
--             AND RIGHT(@email,1) between 'a' AND 'z'  
--               SET @valid=1  
--     RETURN @valid  
--END  


GO
/****** Object:  Table [dbo].[AllocatedClassrooms]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllocatedClassrooms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CourseId] [int] NOT NULL,
	[RoomId] [int] NOT NULL,
	[DayName] [nvarchar](15) NOT NULL,
	[FromTime] [time](7) NOT NULL,
	[ToTime] [time](7) NOT NULL,
	[AllocateFlag] [bit] NOT NULL,
 CONSTRAINT [PK_AllocatedClassrooms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Course]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [nvarchar](100) NOT NULL,
	[CourseName] [nvarchar](100) NOT NULL,
	[CourseCredit] [decimal](2, 1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DepId] [int] NULL,
	[SemId] [int] NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CourseAssignToTeacher]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseAssignToTeacher](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NULL,
	[TeacherId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[AssignFlag] [bit] NOT NULL,
 CONSTRAINT [PK_CourseAssignToTeacher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Department]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepCode] [nvarchar](7) NOT NULL,
	[DepName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Designation]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Designation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DesignationName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Designation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EnrollInCourse]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnrollInCourse](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RegisterStudentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[EnrollDate] [date] NOT NULL,
 CONSTRAINT [PK_EnrollInCourse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RegisterStudent]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegisterStudent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentName] [nvarchar](200) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[ContactNo] [nvarchar](11) NULL,
	[RegDate] [date] NOT NULL,
	[Address] [nvarchar](max) NULL,
	[DeptId] [int] NOT NULL,
	[RegNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_RegisterStudent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomInfo]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoomNo] [nvarchar](50) NULL,
	[FloorNo] [nvarchar](50) NULL,
	[BuildingNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_RoomInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SemesterInfo]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SemesterInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SemesterName] [nvarchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_Semester] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StudentResult]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentResult](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EnrollId] [int] NOT NULL,
	[Grade] [nvarchar](2) NOT NULL,
 CONSTRAINT [PK_StudentResult] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Teacher]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teacher](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TeacherName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](500) NULL,
	[Email] [nvarchar](255) NOT NULL,
	[ContactNo] [nvarchar](11) NULL,
	[DesId] [int] NULL,
	[Credit] [float] NOT NULL,
	[DeptId] [int] NULL,
 CONSTRAINT [PK_Teacher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[ViewCourseStatics]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewCourseStatics]
AS
SELECT        dbo.Course.CourseCode, dbo.Course.CourseName, ISNULL(dbo.Teacher.TeacherName, 'Not-assigned yet') AS AssignedTo, dbo.SemesterInfo.SemesterName, 
                         dbo.Course.DepId
FROM            dbo.SemesterInfo RIGHT OUTER JOIN
                         dbo.Course ON dbo.SemesterInfo.Id = dbo.Course.SemId LEFT OUTER JOIN
                         dbo.Teacher RIGHT OUTER JOIN
                         dbo.CourseAssignToTeacher ON dbo.Teacher.Id = dbo.CourseAssignToTeacher.TeacherId ON dbo.Course.Id = dbo.CourseAssignToTeacher.CourseId

GO
/****** Object:  View [dbo].[ViewRegisterStudent]    Script Date: 11/26/2016 1:47:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewRegisterStudent]
AS
SELECT        dbo.RegisterStudent.StudentName, dbo.RegisterStudent.Email, dbo.RegisterStudent.ContactNo, dbo.RegisterStudent.RegDate, dbo.RegisterStudent.RegNumber, 
                         dbo.Department.DepName
FROM            dbo.RegisterStudent LEFT OUTER JOIN
                         dbo.Department ON dbo.RegisterStudent.DeptId = dbo.Department.Id

GO
SET IDENTITY_INSERT [dbo].[Course] ON 

INSERT [dbo].[Course] ([Id], [CourseCode], [CourseName], [CourseCredit], [Description], [DepId], [SemId]) VALUES (2, N'22222', N'Computer Science & Engineering', CAST(0.6 AS Decimal(2, 1)), N'aaaaaaaaa', 2, 6)
INSERT [dbo].[Course] ([Id], [CourseCode], [CourseName], [CourseCredit], [Description], [DepId], [SemId]) VALUES (5, N'0022223', N'Electric', CAST(5.0 AS Decimal(2, 1)), N'aaaaaaaaa', 3, 6)
SET IDENTITY_INSERT [dbo].[Course] OFF
SET IDENTITY_INSERT [dbo].[CourseAssignToTeacher] ON 

INSERT [dbo].[CourseAssignToTeacher] ([Id], [DepartmentId], [TeacherId], [CourseId], [AssignFlag]) VALUES (5, 2, 5, 2, 1)
SET IDENTITY_INSERT [dbo].[CourseAssignToTeacher] OFF
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (2, N'CSE', N'Computer Science & Engineering')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (4, N'EEE', N'Electrical & Electronic Engineering')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (5, N'Hum', N'Humanities')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (6, N'Arch', N'Architecture')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (13, N'dfgv', N'a11111')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (14, N'abc', N'aaaaaaaaaaaaaa')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (15, N'abc6666', N'aaaaaaaaaaaaaa66')
INSERT [dbo].[Department] ([Id], [DepCode], [DepName]) VALUES (16, N'dep 1', N'depaartment 1')
SET IDENTITY_INSERT [dbo].[Department] OFF
SET IDENTITY_INSERT [dbo].[Designation] ON 

INSERT [dbo].[Designation] ([Id], [DesignationName]) VALUES (3, N'Assistant Professor')
INSERT [dbo].[Designation] ([Id], [DesignationName]) VALUES (2, N'Associate Professor')
INSERT [dbo].[Designation] ([Id], [DesignationName]) VALUES (5, N'Lecturer')
INSERT [dbo].[Designation] ([Id], [DesignationName]) VALUES (1, N'Professor')
INSERT [dbo].[Designation] ([Id], [DesignationName]) VALUES (4, N'Senior Lecturer')
SET IDENTITY_INSERT [dbo].[Designation] OFF
SET IDENTITY_INSERT [dbo].[RegisterStudent] ON 

INSERT [dbo].[RegisterStudent] ([Id], [StudentName], [Email], [ContactNo], [RegDate], [Address], [DeptId], [RegNumber]) VALUES (1, N'Student1', N'student1@gmail.com', N'01234567892', CAST(0xFF3A0B00 AS Date), N'ctg', 2, N'CSE-2016-001')
INSERT [dbo].[RegisterStudent] ([Id], [StudentName], [Email], [ContactNo], [RegDate], [Address], [DeptId], [RegNumber]) VALUES (2, N'Student2', N'student2@gmail.com', N'01234567892', CAST(0x8E390B00 AS Date), N'ctg', 2, N'CSE-2015-002')
INSERT [dbo].[RegisterStudent] ([Id], [StudentName], [Email], [ContactNo], [RegDate], [Address], [DeptId], [RegNumber]) VALUES (3, N'manik1', N'manik@gmnail.com', N'12345678956', CAST(0xFE3A0B00 AS Date), N'ctg', 2, N'CSE-2016-002')
INSERT [dbo].[RegisterStudent] ([Id], [StudentName], [Email], [ContactNo], [RegDate], [Address], [DeptId], [RegNumber]) VALUES (4, N'student 3', N'student3@gmail.com', N'12345678901', CAST(0x0D3C0B00 AS Date), N'dhaka', 4, N'EEE-2016-001')
SET IDENTITY_INSERT [dbo].[RegisterStudent] OFF
SET IDENTITY_INSERT [dbo].[RoomInfo] ON 

INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (1, N'R-101', N'F-1', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (2, N'R-102', N'F-1', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (3, N'R-103', N'F-1', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (4, N'R-201', N'F-2', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (5, N'R-202', N'F-2', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (6, N'R-203', N'F-2', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (7, N'R-301', N'F-3', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (8, N'R-302', N'F-3', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (9, N'R-303', N'F-3', N'B-1')
INSERT [dbo].[RoomInfo] ([Id], [RoomNo], [FloorNo], [BuildingNo]) VALUES (10, N'R-401', N'F-4', N'B-1')
SET IDENTITY_INSERT [dbo].[RoomInfo] OFF
SET IDENTITY_INSERT [dbo].[SemesterInfo] ON 

INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (1, N'Spring Semester', CAST(0x6E390B00 AS Date), CAST(0xE5390B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (2, N'Summer Semester', CAST(0xE6390B00 AS Date), CAST(0x603A0B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (3, N'Fall Semester', CAST(0x613A0B00 AS Date), CAST(0xDA3A0B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (4, N'Spring Semester', CAST(0xDB3A0B00 AS Date), CAST(0x533B0B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (5, N'Summer Semester', CAST(0x543B0B00 AS Date), CAST(0xCE3B0B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (6, N'Fall Semester', CAST(0xCF3B0B00 AS Date), CAST(0x483C0B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (7, N'Spring Semester', CAST(0x493C0B00 AS Date), CAST(0xC03C0B00 AS Date))
INSERT [dbo].[SemesterInfo] ([Id], [SemesterName], [StartDate], [EndDate]) VALUES (8, N'Summer Semester', CAST(0xC13C0B00 AS Date), CAST(0x3B3D0B00 AS Date))
SET IDENTITY_INSERT [dbo].[SemesterInfo] OFF
SET IDENTITY_INSERT [dbo].[Teacher] ON 

INSERT [dbo].[Teacher] ([Id], [TeacherName], [Address], [Email], [ContactNo], [DesId], [Credit], [DeptId]) VALUES (1, N'Mohshin', N'Chittagong', N'mohshin@yahoo.com', N'01671473723', 1, 20, 2)
INSERT [dbo].[Teacher] ([Id], [TeacherName], [Address], [Email], [ContactNo], [DesId], [Credit], [DeptId]) VALUES (4, N'ddd', N'dd', N'dd', N'12345678901', 1, 1, 2)
INSERT [dbo].[Teacher] ([Id], [TeacherName], [Address], [Email], [ContactNo], [DesId], [Credit], [DeptId]) VALUES (5, N'mmmm', N'ctg', N'mdmohshin4u@gmail.com', N'12344', 5, 12, 4)
INSERT [dbo].[Teacher] ([Id], [TeacherName], [Address], [Email], [ContactNo], [DesId], [Credit], [DeptId]) VALUES (6, N'Teacher1', N'ctg', N'teacher@gmail.com', N'12121', 3, 20, 2)
INSERT [dbo].[Teacher] ([Id], [TeacherName], [Address], [Email], [ContactNo], [DesId], [Credit], [DeptId]) VALUES (7, N'Teacher2', N'ctg', N'teacher2@gmail.com', N'3434343', 2, 18, 2)
SET IDENTITY_INSERT [dbo].[Teacher] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Course_CourseCode]    Script Date: 11/26/2016 1:47:05 PM ******/
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [UK_Course_CourseCode] UNIQUE NONCLUSTERED 
(
	[CourseCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Course_CourseName]    Script Date: 11/26/2016 1:47:05 PM ******/
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [UK_Course_CourseName] UNIQUE NONCLUSTERED 
(
	[CourseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Department_DepCode]    Script Date: 11/26/2016 1:47:05 PM ******/
ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [UK_Department_DepCode] UNIQUE NONCLUSTERED 
(
	[DepCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Department_DepName]    Script Date: 11/26/2016 1:47:05 PM ******/
ALTER TABLE [dbo].[Department] ADD  CONSTRAINT [UK_Department_DepName] UNIQUE NONCLUSTERED 
(
	[DepName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Designation_DesignationName]    Script Date: 11/26/2016 1:47:05 PM ******/
ALTER TABLE [dbo].[Designation] ADD  CONSTRAINT [UK_Designation_DesignationName] UNIQUE NONCLUSTERED 
(
	[DesignationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Teacher_Email]    Script Date: 11/26/2016 1:47:05 PM ******/
ALTER TABLE [dbo].[Teacher] ADD  CONSTRAINT [UK_Teacher_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AllocatedClassrooms] ADD  CONSTRAINT [DF_AllocatedClassrooms_AllocateFlag]  DEFAULT ((1)) FOR [AllocateFlag]
GO
ALTER TABLE [dbo].[CourseAssignToTeacher] ADD  CONSTRAINT [DF_CourseAssignToTeacher_AssiignFlag]  DEFAULT ((1)) FOR [AssignFlag]
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [CK__CourseCreditRange] CHECK  (([CourseCredit]>=(0.5) AND [CourseCredit]<=(5.0)))
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [CK__CourseCreditRange]
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [CK_CourseCodeLength] CHECK  ((len([CourseCode])>=(5)))
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [CK_CourseCodeLength]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [CK_DepCodeLength] CHECK  ((len([DepCode])>=(2) AND len([DepCode])<=(7)))
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [CK_DepCodeLength]
GO
ALTER TABLE [dbo].[Teacher]  WITH CHECK ADD  CONSTRAINT [CK_Credit_Non_Negative] CHECK  (([Credit]>=(0)))
GO
ALTER TABLE [dbo].[Teacher] CHECK CONSTRAINT [CK_Credit_Non_Negative]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Range from 0.5 to 0.5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Course', @level2type=N'CONSTRAINT',@level2name=N'CK__CourseCreditRange'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'minimum 5 charcter long' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Course', @level2type=N'CONSTRAINT',@level2name=N'CK_CourseCodeLength'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Length must be 2 to 7 charecter' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Department', @level2type=N'CONSTRAINT',@level2name=N'CK_DepCodeLength'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Teacher', @level2type=N'COLUMN',@level2name=N'Credit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[47] 2[25] 3) )"
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
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Course"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 189
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CourseAssignToTeacher"
            Begin Extent = 
               Top = 9
               Left = 463
               Bottom = 175
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Teacher"
            Begin Extent = 
               Top = 23
               Left = 771
               Bottom = 181
               Right = 941
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SemesterInfo"
            Begin Extent = 
               Top = 132
               Left = 294
               Bottom = 261
               Right = 469
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1755
         Width = 2535
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
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
         Or = 13' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCourseStatics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'50
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCourseStatics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCourseStatics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[43] 2[19] 3) )"
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
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "RegisterStudent"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 186
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Department"
            Begin Extent = 
               Top = 15
               Left = 383
               Bottom = 127
               Right = 553
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewRegisterStudent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewRegisterStudent'
GO
USE [master]
GO
ALTER DATABASE [UniversityDB] SET  READ_WRITE 
GO
