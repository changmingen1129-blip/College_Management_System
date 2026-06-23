/*
 College Management System - SQL Server Database
 Generated from the ASP.NET Web Forms source code in:
 https://github.com/changmingen1129-blip/College_Management_System

 IMPORTANT:
 1. Run this entire script in SQL Server Management Studio (SSMS).
 2. It creates database: CollegeManagementDB
 3. It creates the tables and sample accounts required by the system.
 4. Existing CollegeManagementDB will NOT be deleted automatically.
*/

USE master;
GO

IF DB_ID(N'CollegeManagementDB') IS NULL
BEGIN
    CREATE DATABASE CollegeManagementDB;
END
GO

USE CollegeManagementDB;
GO

/* =========================================================
   1. ADMIN USER
   ========================================================= */
IF OBJECT_ID(N'dbo.AdminUser', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AdminUser
    (
        AdminID     INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_AdminUser PRIMARY KEY,
        AdminName   VARCHAR(100) NOT NULL,
        Email       VARCHAR(150) NOT NULL,
        Password    VARCHAR(100) NOT NULL,
        CreatedAt   DATETIME NOT NULL
            CONSTRAINT DF_AdminUser_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_AdminUser_Email UNIQUE (Email)
    );
END
GO

/* =========================================================
   2. PROGRAMME
   ========================================================= */
IF OBJECT_ID(N'dbo.Programme', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Programme
    (
        ProgrammeID    INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Programme PRIMARY KEY,
        ProgrammeName  VARCHAR(150) NOT NULL,
        ProgrammeCode  VARCHAR(30) NOT NULL,
        CreatedAt      DATETIME NOT NULL
            CONSTRAINT DF_Programme_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_Programme_Code UNIQUE (ProgrammeCode)
    );
END
GO

/* =========================================================
   3. STUDENT
   ========================================================= */
IF OBJECT_ID(N'dbo.Student', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Student
    (
        StudentID     INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Student PRIMARY KEY,
        StudentName   VARCHAR(150) NOT NULL,
        Email         VARCHAR(150) NOT NULL,
        Password      VARCHAR(100) NOT NULL
            CONSTRAINT DF_Student_Password DEFAULT '123456',
        ProgrammeID   INT NULL,
        Phone         VARCHAR(30) NULL,
        CreatedAt     DATETIME NOT NULL
            CONSTRAINT DF_Student_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_Student_Email UNIQUE (Email),
        CONSTRAINT FK_Student_Programme
            FOREIGN KEY (ProgrammeID)
            REFERENCES dbo.Programme(ProgrammeID)
    );
END
GO

/* =========================================================
   4. LECTURER
   ========================================================= */
IF OBJECT_ID(N'dbo.Lecturer', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Lecturer
    (
        LecturerID     INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Lecturer PRIMARY KEY,
        LecturerName   VARCHAR(150) NOT NULL,
        Email          VARCHAR(150) NOT NULL,
        Phone          VARCHAR(30) NULL,
        Password       VARCHAR(100) NOT NULL
            CONSTRAINT DF_Lecturer_Password DEFAULT '123456',
        CreatedAt      DATETIME NOT NULL
            CONSTRAINT DF_Lecturer_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_Lecturer_Email UNIQUE (Email)
    );
END
GO

/* =========================================================
   5. COURSE
   CourseFee is required by AdminFees.aspx.cs
   ========================================================= */
IF OBJECT_ID(N'dbo.Course', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Course
    (
        CourseID      INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Course PRIMARY KEY,
        CourseName    VARCHAR(150) NOT NULL,
        CourseCode    VARCHAR(30) NOT NULL,
        CreditHours   INT NOT NULL,
        ProgrammeID   INT NOT NULL,
        CourseFee     DECIMAL(10,2) NOT NULL
            CONSTRAINT DF_Course_CourseFee DEFAULT 0,
        CreatedAt     DATETIME NOT NULL
            CONSTRAINT DF_Course_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_Course_Code UNIQUE (CourseCode),
        CONSTRAINT CK_Course_CreditHours CHECK (CreditHours > 0),
        CONSTRAINT CK_Course_CourseFee CHECK (CourseFee >= 0),
        CONSTRAINT FK_Course_Programme
            FOREIGN KEY (ProgrammeID)
            REFERENCES dbo.Programme(ProgrammeID)
    );
END
ELSE
BEGIN
    IF COL_LENGTH('dbo.Course', 'CourseFee') IS NULL
    BEGIN
        ALTER TABLE dbo.Course
        ADD CourseFee DECIMAL(10,2) NOT NULL
            CONSTRAINT DF_Course_CourseFee_Added DEFAULT 0;
    END
END
GO

/* =========================================================
   6. LECTURER COURSE ASSIGNMENT
   ========================================================= */
IF OBJECT_ID(N'dbo.LecturerCourse', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LecturerCourse
    (
        LecturerCourseID  INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_LecturerCourse PRIMARY KEY,
        LecturerID        INT NOT NULL,
        CourseID          INT NOT NULL,
        AssignedAt        DATETIME NOT NULL
            CONSTRAINT DF_LecturerCourse_AssignedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_LecturerCourse UNIQUE (LecturerID, CourseID),
        CONSTRAINT FK_LecturerCourse_Lecturer
            FOREIGN KEY (LecturerID)
            REFERENCES dbo.Lecturer(LecturerID),
        CONSTRAINT FK_LecturerCourse_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID)
    );
END
GO

/* =========================================================
   7. ENROLMENT
   ========================================================= */
IF OBJECT_ID(N'dbo.Enrolment', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Enrolment
    (
        EnrolmentID   INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Enrolment PRIMARY KEY,
        StudentID     INT NOT NULL,
        CourseID      INT NOT NULL,
        EnrolDate     DATETIME NOT NULL
            CONSTRAINT DF_Enrolment_EnrolDate DEFAULT GETDATE(),
        Status        VARCHAR(30) NOT NULL
            CONSTRAINT DF_Enrolment_Status DEFAULT 'Enrolled',

        CONSTRAINT UQ_Enrolment UNIQUE (StudentID, CourseID),
        CONSTRAINT FK_Enrolment_Student
            FOREIGN KEY (StudentID)
            REFERENCES dbo.Student(StudentID),
        CONSTRAINT FK_Enrolment_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID)
    );
END
GO

/* =========================================================
   8. SCHEDULE
   ========================================================= */
IF OBJECT_ID(N'dbo.Schedule', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Schedule
    (
        ScheduleID   INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Schedule PRIMARY KEY,
        CourseID     INT NOT NULL,
        LecturerID   INT NULL,
        DayOfWeek    VARCHAR(20) NOT NULL,
        StartTime    TIME(0) NOT NULL,
        EndTime      TIME(0) NOT NULL,
        Room         VARCHAR(100) NOT NULL,
        CreatedAt    DATETIME NOT NULL
            CONSTRAINT DF_Schedule_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT CK_Schedule_Time CHECK (StartTime < EndTime),
        CONSTRAINT CK_Schedule_Day CHECK
        (
            DayOfWeek IN
            ('Monday','Tuesday','Wednesday','Thursday',
             'Friday','Saturday','Sunday')
        ),
        CONSTRAINT FK_Schedule_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID),
        CONSTRAINT FK_Schedule_Lecturer
            FOREIGN KEY (LecturerID)
            REFERENCES dbo.Lecturer(LecturerID)
    );
END
GO

/* =========================================================
   9. ATTENDANCE
   ========================================================= */
IF OBJECT_ID(N'dbo.Attendance', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Attendance
    (
        AttendanceID    INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Attendance PRIMARY KEY,
        StudentID       INT NOT NULL,
        CourseID        INT NOT NULL,
        LecturerID      INT NOT NULL,
        ScheduleID      INT NULL,
        AttendanceDate  DATE NOT NULL,
        Status          VARCHAR(20) NOT NULL,
        Remarks         VARCHAR(255) NULL,
        CreatedAt       DATETIME NOT NULL
            CONSTRAINT DF_Attendance_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_Attendance
            UNIQUE (StudentID, CourseID, LecturerID, AttendanceDate),
        CONSTRAINT CK_Attendance_Status
            CHECK (Status IN ('Present','Absent','Late','Excused')),
        CONSTRAINT FK_Attendance_Student
            FOREIGN KEY (StudentID)
            REFERENCES dbo.Student(StudentID),
        CONSTRAINT FK_Attendance_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID),
        CONSTRAINT FK_Attendance_Lecturer
            FOREIGN KEY (LecturerID)
            REFERENCES dbo.Lecturer(LecturerID),
        CONSTRAINT FK_Attendance_Schedule
            FOREIGN KEY (ScheduleID)
            REFERENCES dbo.Schedule(ScheduleID)
    );
END
GO

/* =========================================================
   10. ASSESSMENT
   ========================================================= */
IF OBJECT_ID(N'dbo.Assessment', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Assessment
    (
        AssessmentID    INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Assessment PRIMARY KEY,
        CourseID        INT NOT NULL,
        LecturerID      INT NOT NULL,
        AssessmentName  VARCHAR(100) NOT NULL,
        MaxMark         DECIMAL(5,2) NOT NULL,
        Weightage       DECIMAL(5,2) NOT NULL,
        CreatedAt       DATETIME NOT NULL
            CONSTRAINT DF_Assessment_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_Assessment
            UNIQUE (CourseID, LecturerID, AssessmentName),
        CONSTRAINT CK_Assessment_MaxMark
            CHECK (MaxMark > 0),
        CONSTRAINT CK_Assessment_Weightage
            CHECK (Weightage > 0 AND Weightage <= 100),
        CONSTRAINT FK_Assessment_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID),
        CONSTRAINT FK_Assessment_Lecturer
            FOREIGN KEY (LecturerID)
            REFERENCES dbo.Lecturer(LecturerID)
    );
END
GO

/* =========================================================
   11. STUDENT MARK
   ========================================================= */
IF OBJECT_ID(N'dbo.StudentMark', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.StudentMark
    (
        MarkID         INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_StudentMark PRIMARY KEY,
        AssessmentID   INT NOT NULL,
        StudentID      INT NOT NULL,
        MarkObtained   DECIMAL(5,2) NOT NULL,
        Remarks        VARCHAR(255) NULL,
        CreatedAt      DATETIME NOT NULL
            CONSTRAINT DF_StudentMark_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT UQ_StudentMark UNIQUE (AssessmentID, StudentID),
        CONSTRAINT CK_StudentMark_NonNegative CHECK (MarkObtained >= 0),
        CONSTRAINT FK_StudentMark_Assessment
            FOREIGN KEY (AssessmentID)
            REFERENCES dbo.Assessment(AssessmentID),
        CONSTRAINT FK_StudentMark_Student
            FOREIGN KEY (StudentID)
            REFERENCES dbo.Student(StudentID)
    );
END
GO

/* =========================================================
   12. ANNOUNCEMENT
   ========================================================= */
IF OBJECT_ID(N'dbo.Announcement', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Announcement
    (
        AnnouncementID  INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Announcement PRIMARY KEY,
        Title           VARCHAR(150) NOT NULL,
        Message         VARCHAR(MAX) NOT NULL,
        Audience        VARCHAR(30) NOT NULL,
        CourseID        INT NULL,
        CreatedByRole   VARCHAR(30) NOT NULL,
        CreatedByID     INT NULL,
        CreatedAt       DATETIME NOT NULL
            CONSTRAINT DF_Announcement_CreatedAt DEFAULT GETDATE(),
        ExpiryDate      DATE NULL,
        IsActive        BIT NOT NULL
            CONSTRAINT DF_Announcement_IsActive DEFAULT 1,

        CONSTRAINT FK_Announcement_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID)
    );
END
GO

/* =========================================================
   13. ACADEMIC CALENDAR
   ========================================================= */
IF OBJECT_ID(N'dbo.AcademicCalendar', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AcademicCalendar
    (
        EventID           INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_AcademicCalendar PRIMARY KEY,
        EventTitle        VARCHAR(150) NOT NULL,
        EventDescription  VARCHAR(MAX) NULL,
        EventType         VARCHAR(50) NOT NULL,
        StartDate         DATETIME NOT NULL,
        EndDate           DATETIME NOT NULL,
        Audience          VARCHAR(30) NOT NULL,
        Location          VARCHAR(150) NULL,
        CreatedByRole     VARCHAR(30) NOT NULL
            CONSTRAINT DF_AcademicCalendar_CreatedByRole DEFAULT 'Admin',
        CreatedByID       INT NULL,
        CreatedAt         DATETIME NOT NULL
            CONSTRAINT DF_AcademicCalendar_CreatedAt DEFAULT GETDATE(),
        IsActive          BIT NOT NULL
            CONSTRAINT DF_AcademicCalendar_IsActive DEFAULT 1,

        CONSTRAINT CK_AcademicCalendar_Date
            CHECK (EndDate >= StartDate)
    );
END
GO

/* =========================================================
   14. STUDENT FEE
   ========================================================= */
IF OBJECT_ID(N'dbo.StudentFee', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.StudentFee
    (
        FeeID          INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_StudentFee PRIMARY KEY,
        StudentID      INT NOT NULL,
        CourseID       INT NULL,
        FeeType        VARCHAR(100) NOT NULL,
        Description    VARCHAR(255) NULL,
        TotalAmount    DECIMAL(10,2) NOT NULL,
        PaidAmount     DECIMAL(10,2) NOT NULL
            CONSTRAINT DF_StudentFee_PaidAmount DEFAULT 0,
        DueDate        DATE NOT NULL,
        PaymentStatus  VARCHAR(30) NOT NULL
            CONSTRAINT DF_StudentFee_PaymentStatus DEFAULT 'Unpaid',
        CreatedAt      DATETIME NOT NULL
            CONSTRAINT DF_StudentFee_CreatedAt DEFAULT GETDATE(),

        CONSTRAINT CK_StudentFee_TotalAmount
            CHECK (TotalAmount >= 0),
        CONSTRAINT CK_StudentFee_PaidAmount
            CHECK (PaidAmount >= 0),
        CONSTRAINT FK_StudentFee_Student
            FOREIGN KEY (StudentID)
            REFERENCES dbo.Student(StudentID),
        CONSTRAINT FK_StudentFee_Course
            FOREIGN KEY (CourseID)
            REFERENCES dbo.Course(CourseID)
    );
END
GO

/* =========================================================
   15. FEE PAYMENT
   ========================================================= */
IF OBJECT_ID(N'dbo.FeePayment', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.FeePayment
    (
        PaymentID       INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_FeePayment PRIMARY KEY,
        FeeID           INT NOT NULL,
        StudentID       INT NOT NULL,
        PaymentAmount   DECIMAL(10,2) NOT NULL,
        PaymentMethod   VARCHAR(50) NOT NULL,
        ReferenceNumber VARCHAR(100) NOT NULL,
        PaymentDate     DATETIME NOT NULL
            CONSTRAINT DF_FeePayment_PaymentDate DEFAULT GETDATE(),
        PaymentStatus   VARCHAR(30) NOT NULL
            CONSTRAINT DF_FeePayment_Status DEFAULT 'Successful',

        CONSTRAINT UQ_FeePayment_Reference UNIQUE (ReferenceNumber),
        CONSTRAINT CK_FeePayment_Amount CHECK (PaymentAmount > 0),
        CONSTRAINT FK_FeePayment_Fee
            FOREIGN KEY (FeeID)
            REFERENCES dbo.StudentFee(FeeID),
        CONSTRAINT FK_FeePayment_Student
            FOREIGN KEY (StudentID)
            REFERENCES dbo.Student(StudentID)
    );
END
GO

/* =========================================================
   INDEXES
   ========================================================= */
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Student_ProgrammeID'
      AND object_id = OBJECT_ID('dbo.Student')
)
    CREATE INDEX IX_Student_ProgrammeID
    ON dbo.Student(ProgrammeID);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Course_ProgrammeID'
      AND object_id = OBJECT_ID('dbo.Course')
)
    CREATE INDEX IX_Course_ProgrammeID
    ON dbo.Course(ProgrammeID);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Enrolment_StudentID'
      AND object_id = OBJECT_ID('dbo.Enrolment')
)
    CREATE INDEX IX_Enrolment_StudentID
    ON dbo.Enrolment(StudentID);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_Enrolment_CourseID'
      AND object_id = OBJECT_ID('dbo.Enrolment')
)
    CREATE INDEX IX_Enrolment_CourseID
    ON dbo.Enrolment(CourseID);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_StudentFee_StudentID'
      AND object_id = OBJECT_ID('dbo.StudentFee')
)
    CREATE INDEX IX_StudentFee_StudentID
    ON dbo.StudentFee(StudentID);
GO

/* =========================================================
   SAMPLE DATA
   ========================================================= */

-- Admin login:
-- Email: admin@college.com
-- Password: admin123
IF NOT EXISTS
(
    SELECT 1 FROM dbo.AdminUser
    WHERE Email = 'admin@college.com'
)
BEGIN
    INSERT INTO dbo.AdminUser
        (AdminName, Email, Password)
    VALUES
        ('System Administrator', 'admin@college.com', 'admin123');
END
GO

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Programme
    WHERE ProgrammeCode = 'DIT'
)
BEGIN
    INSERT INTO dbo.Programme
        (ProgrammeName, ProgrammeCode)
    VALUES
        ('Diploma in Information Technology', 'DIT');
END
GO

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Programme
    WHERE ProgrammeCode = 'DCS'
)
BEGIN
    INSERT INTO dbo.Programme
        (ProgrammeName, ProgrammeCode)
    VALUES
        ('Diploma in Computer Science', 'DCS');
END
GO

DECLARE @DITProgrammeID INT;
SELECT @DITProgrammeID = ProgrammeID
FROM dbo.Programme
WHERE ProgrammeCode = 'DIT';

-- Lecturer login:
-- Email: lecturer@college.com
-- Password: 123456
IF NOT EXISTS
(
    SELECT 1 FROM dbo.Lecturer
    WHERE Email = 'lecturer@college.com'
)
BEGIN
    INSERT INTO dbo.Lecturer
        (LecturerName, Email, Phone, Password)
    VALUES
        ('Demo Lecturer', 'lecturer@college.com', '0123456789', '123456');
END

-- Student login:
-- Email: student@college.com
-- Password: 123456
IF NOT EXISTS
(
    SELECT 1 FROM dbo.Student
    WHERE Email = 'student@college.com'
)
BEGIN
    INSERT INTO dbo.Student
        (StudentName, Email, Password, ProgrammeID, Phone)
    VALUES
        ('Demo Student', 'student@college.com', '123456',
         @DITProgrammeID, '0112345678');
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Course
    WHERE CourseCode = 'DIT101'
)
BEGIN
    INSERT INTO dbo.Course
        (CourseName, CourseCode, CreditHours, ProgrammeID, CourseFee)
    VALUES
        ('Programming Fundamentals', 'DIT101', 3,
         @DITProgrammeID, 1200.00);
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Course
    WHERE CourseCode = 'DIT102'
)
BEGIN
    INSERT INTO dbo.Course
        (CourseName, CourseCode, CreditHours, ProgrammeID, CourseFee)
    VALUES
        ('Database Systems', 'DIT102', 3,
         @DITProgrammeID, 1300.00);
END
GO

DECLARE @LecturerID INT;
DECLARE @StudentID INT;
DECLARE @CourseID INT;

SELECT @LecturerID = LecturerID
FROM dbo.Lecturer
WHERE Email = 'lecturer@college.com';

SELECT @StudentID = StudentID
FROM dbo.Student
WHERE Email = 'student@college.com';

SELECT @CourseID = CourseID
FROM dbo.Course
WHERE CourseCode = 'DIT101';

IF NOT EXISTS
(
    SELECT 1 FROM dbo.LecturerCourse
    WHERE LecturerID = @LecturerID
      AND CourseID = @CourseID
)
BEGIN
    INSERT INTO dbo.LecturerCourse
        (LecturerID, CourseID)
    VALUES
        (@LecturerID, @CourseID);
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Enrolment
    WHERE StudentID = @StudentID
      AND CourseID = @CourseID
)
BEGIN
    INSERT INTO dbo.Enrolment
        (StudentID, CourseID, EnrolDate, Status)
    VALUES
        (@StudentID, @CourseID, GETDATE(), 'Enrolled');
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Schedule
    WHERE CourseID = @CourseID
      AND DayOfWeek = 'Monday'
      AND StartTime = '09:00'
)
BEGIN
    INSERT INTO dbo.Schedule
        (CourseID, LecturerID, DayOfWeek,
         StartTime, EndTime, Room)
    VALUES
        (@CourseID, @LecturerID, 'Monday',
         '09:00', '11:00', 'Lab 1');
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.StudentFee
    WHERE StudentID = @StudentID
      AND CourseID = @CourseID
      AND FeeType = 'Course Fee'
)
BEGIN
    INSERT INTO dbo.StudentFee
    (
        StudentID, CourseID, FeeType, Description,
        TotalAmount, PaidAmount, DueDate, PaymentStatus
    )
    VALUES
    (
        @StudentID, @CourseID, 'Course Fee',
        'Programming Fundamentals course fee',
        1200.00, 0.00,
        DATEADD(DAY, 30, CAST(GETDATE() AS DATE)),
        'Unpaid'
    );
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Announcement
    WHERE Title = 'Welcome to the College Management System'
)
BEGIN
    INSERT INTO dbo.Announcement
    (
        Title, Message, Audience, CourseID,
        CreatedByRole, CreatedByID,
        ExpiryDate, IsActive
    )
    VALUES
    (
        'Welcome to the College Management System',
        'The system is ready for student and lecturer use.',
        'All', NULL,
        'Admin', NULL,
        DATEADD(DAY, 90, CAST(GETDATE() AS DATE)), 1
    );
END

IF NOT EXISTS
(
    SELECT 1 FROM dbo.AcademicCalendar
    WHERE EventTitle = 'Semester Registration'
)
BEGIN
    INSERT INTO dbo.AcademicCalendar
    (
        EventTitle, EventDescription, EventType,
        StartDate, EndDate, Audience, Location,
        CreatedByRole, CreatedByID, IsActive
    )
    VALUES
    (
        'Semester Registration',
        'Registration period for the new semester.',
        'Registration',
        CAST(GETDATE() AS DATE),
        DATEADD(DAY, 7, CAST(GETDATE() AS DATE)),
        'All',
        'Administration Office',
        'Admin',
        NULL,
        1
    );
END
GO

/* =========================================================
   FINAL VERIFICATION
   ========================================================= */
PRINT 'CollegeManagementDB database setup completed successfully.';
PRINT 'Admin: admin@college.com / admin123';
PRINT 'Lecturer: lecturer@college.com / 123456';
PRINT 'Student: student@college.com / 123456';

SELECT
    (SELECT COUNT(*) FROM dbo.AdminUser) AS AdminUsers,
    (SELECT COUNT(*) FROM dbo.Programme) AS Programmes,
    (SELECT COUNT(*) FROM dbo.Student) AS Students,
    (SELECT COUNT(*) FROM dbo.Lecturer) AS Lecturers,
    (SELECT COUNT(*) FROM dbo.Course) AS Courses,
    (SELECT COUNT(*) FROM dbo.Enrolment) AS Enrolments,
    (SELECT COUNT(*) FROM dbo.StudentFee) AS StudentFees;
GO
