/*
 College Management System - Lecturer Progress Demonstration Data

 PURPOSE
 Creates a controlled set of attendance and assessment data so the
 Lecturer Progress page displays:
   - Alice Lee: Good Standing
   - Brandon Wong: Warning
   - Demo Student: High Risk

 RUN ORDER
 1. CollegeManagementDB.sql
 2. CollegeManagementDummyData.sql
 3. CollegeManagementProgressTestData.sql

 NOTE
 This script resets attendance for the three demonstration students in
 DIT101 before inserting the controlled progress records.
*/

USE CollegeManagementDB;
GO
SET NOCOUNT ON;
GO

DECLARE @LecturerID INT =
(
    SELECT LecturerID
    FROM dbo.Lecturer
    WHERE Email = 'sarah.lim@college.com'
);

DECLARE @CourseID INT =
(
    SELECT CourseID
    FROM dbo.Course
    WHERE CourseCode = 'DIT101'
);

DECLARE @AliceID INT =
(
    SELECT StudentID
    FROM dbo.Student
    WHERE Email = 'alice.lee@student.com'
);

DECLARE @BrandonID INT =
(
    SELECT StudentID
    FROM dbo.Student
    WHERE Email = 'brandon.wong@student.com'
);

DECLARE @DemoID INT =
(
    SELECT StudentID
    FROM dbo.Student
    WHERE Email = 'student@college.com'
);

IF @LecturerID IS NULL OR @CourseID IS NULL
   OR @AliceID IS NULL OR @BrandonID IS NULL OR @DemoID IS NULL
BEGIN
    THROW 50001,
          'Required demo lecturer, course, or student data is missing. Run the first two database scripts before this script.',
          1;
END;

/* Ensure Sarah Lim is assigned to DIT101. */
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.LecturerCourse
    WHERE LecturerID = @LecturerID
      AND CourseID = @CourseID
)
BEGIN
    INSERT INTO dbo.LecturerCourse (LecturerID, CourseID)
    VALUES (@LecturerID, @CourseID);
END;

/* Ensure all three students have active enrolments in DIT101. */
DECLARE @Students TABLE (StudentID INT PRIMARY KEY);
INSERT INTO @Students (StudentID)
VALUES (@AliceID), (@BrandonID), (@DemoID);

UPDATE e
SET e.Status = 'Enrolled'
FROM dbo.Enrolment e
INNER JOIN @Students s ON s.StudentID = e.StudentID
WHERE e.CourseID = @CourseID;

INSERT INTO dbo.Enrolment (StudentID, CourseID, Status)
SELECT s.StudentID, @CourseID, 'Enrolled'
FROM @Students s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Enrolment e
    WHERE e.StudentID = s.StudentID
      AND e.CourseID = @CourseID
);

/* Create or locate one controlled assessment. */
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Assessment
    WHERE CourseID = @CourseID
      AND LecturerID = @LecturerID
      AND AssessmentName = 'Progress Test'
)
BEGIN
    INSERT INTO dbo.Assessment
    (
        CourseID,
        LecturerID,
        AssessmentName,
        MaxMark,
        Weightage
    )
    VALUES
    (
        @CourseID,
        @LecturerID,
        'Progress Test',
        100,
        20
    );
END;

DECLARE @AssessmentID INT =
(
    SELECT AssessmentID
    FROM dbo.Assessment
    WHERE CourseID = @CourseID
      AND LecturerID = @LecturerID
      AND AssessmentName = 'Progress Test'
);

/* Upsert marks. */
MERGE dbo.StudentMark AS target
USING
(
    SELECT @AssessmentID AS AssessmentID,
           @AliceID AS StudentID,
           CAST(80 AS DECIMAL(5,2)) AS MarkObtained,
           'Good performance' AS Remarks
    UNION ALL
    SELECT @AssessmentID, @BrandonID, CAST(70 AS DECIMAL(5,2)), 'Satisfactory performance'
    UNION ALL
    SELECT @AssessmentID, @DemoID, CAST(30 AS DECIMAL(5,2)), 'Low performance'
) AS source
ON target.AssessmentID = source.AssessmentID
AND target.StudentID = source.StudentID
WHEN MATCHED THEN
    UPDATE SET
        MarkObtained = source.MarkObtained,
        Remarks = source.Remarks
WHEN NOT MATCHED THEN
    INSERT (AssessmentID, StudentID, MarkObtained, Remarks)
    VALUES (source.AssessmentID, source.StudentID, source.MarkObtained, source.Remarks);

/* Reset controlled attendance records for these students and course. */
DELETE a
FROM dbo.Attendance a
INNER JOIN @Students s ON s.StudentID = a.StudentID
WHERE a.CourseID = @CourseID
  AND a.LecturerID = @LecturerID;

/* Alice Lee: 5/5 present = Good Standing. */
INSERT INTO dbo.Attendance
    (StudentID, CourseID, LecturerID, AttendanceDate, Status, Remarks)
VALUES
    (@AliceID, @CourseID, @LecturerID, '2026-05-04', 'Present', 'Demo progress data'),
    (@AliceID, @CourseID, @LecturerID, '2026-05-11', 'Present', 'Demo progress data'),
    (@AliceID, @CourseID, @LecturerID, '2026-05-18', 'Present', 'Demo progress data'),
    (@AliceID, @CourseID, @LecturerID, '2026-05-25', 'Present', 'Demo progress data'),
    (@AliceID, @CourseID, @LecturerID, '2026-06-01', 'Present', 'Demo progress data');

/* Brandon Wong: 3/5 present = Warning. */
INSERT INTO dbo.Attendance
    (StudentID, CourseID, LecturerID, AttendanceDate, Status, Remarks)
VALUES
    (@BrandonID, @CourseID, @LecturerID, '2026-05-04', 'Present', 'Demo progress data'),
    (@BrandonID, @CourseID, @LecturerID, '2026-05-11', 'Present', 'Demo progress data'),
    (@BrandonID, @CourseID, @LecturerID, '2026-05-18', 'Present', 'Demo progress data'),
    (@BrandonID, @CourseID, @LecturerID, '2026-05-25', 'Absent', 'Demo progress data'),
    (@BrandonID, @CourseID, @LecturerID, '2026-06-01', 'Absent', 'Demo progress data');

/* Demo Student: 2/5 present and 30 marks = High Risk. */
INSERT INTO dbo.Attendance
    (StudentID, CourseID, LecturerID, AttendanceDate, Status, Remarks)
VALUES
    (@DemoID, @CourseID, @LecturerID, '2026-05-04', 'Present', 'Demo progress data'),
    (@DemoID, @CourseID, @LecturerID, '2026-05-11', 'Present', 'Demo progress data'),
    (@DemoID, @CourseID, @LecturerID, '2026-05-18', 'Absent', 'Demo progress data'),
    (@DemoID, @CourseID, @LecturerID, '2026-05-25', 'Absent', 'Demo progress data'),
    (@DemoID, @CourseID, @LecturerID, '2026-06-01', 'Absent', 'Demo progress data');

PRINT 'Lecturer progress demonstration data created successfully.';

SELECT
    s.StudentName,
    c.CourseCode,
    a.AttendanceDate,
    a.Status
FROM dbo.Attendance a
INNER JOIN dbo.Student s ON s.StudentID = a.StudentID
INNER JOIN dbo.Course c ON c.CourseID = a.CourseID
WHERE a.CourseID = @CourseID
  AND a.LecturerID = @LecturerID
ORDER BY s.StudentName, a.AttendanceDate;
GO
