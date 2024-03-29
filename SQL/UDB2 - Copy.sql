
CREATE DATABASE [UniversityDB]


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


CREATE VIEW [dbo].[ViewCourseStatics]
AS
SELECT        dbo.Course.CourseCode, dbo.Course.CourseName, ISNULL(dbo.Teacher.TeacherName, 'Not-assigned yet') AS AssignedTo, dbo.SemesterInfo.SemesterName, 
                         dbo.Course.DepId
FROM            dbo.SemesterInfo RIGHT OUTER JOIN
                         dbo.Course ON dbo.SemesterInfo.Id = dbo.Course.SemId LEFT OUTER JOIN
                         dbo.Teacher RIGHT OUTER JOIN
                         dbo.CourseAssignToTeacher ON dbo.Teacher.Id = dbo.CourseAssignToTeacher.TeacherId ON dbo.Course.Id = dbo.CourseAssignToTeacher.CourseId


CREATE VIEW [dbo].[ViewRegisterStudent]
AS
SELECT        dbo.RegisterStudent.StudentName, dbo.RegisterStudent.Email, dbo.RegisterStudent.ContactNo, dbo.RegisterStudent.RegDate, dbo.RegisterStudent.RegNumber, 
                         dbo.Department.DepName
FROM            dbo.RegisterStudent LEFT OUTER JOIN
                         dbo.Department ON dbo.RegisterStudent.DeptId = dbo.Department.Id

