
--CREATE DATABASE [UniversityDB]

USE [UniversityDB]
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


CREATE FUNCTION [dbo].[ValidEmailFunc]( @Temp nvarchar(255))   
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

CREATE TABLE [dbo].[Department](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepCode] [nvarchar](7) NOT NULL,
	[DepName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[Designation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DesignationName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Designation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


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


CREATE TABLE [dbo].[SemesterInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SemesterName] [nvarchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[SemesterName2] [nvarchar](50) NULL,
 CONSTRAINT [PK_Semester] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[StudentResult](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EnrollId] [int] NOT NULL,
	[Grade] [nvarchar](2) NOT NULL,
 CONSTRAINT [PK_StudentResult] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


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

