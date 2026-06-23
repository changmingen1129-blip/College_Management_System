
USE CollegeManagementDB;
GO

/* =========================================================
   DUMMY DATA FOR COLLEGE MANAGEMENT SYSTEM
   Run this AFTER CollegeManagementDB.sql
   ========================================================= */

/* PROGRAMMES */
IF NOT EXISTS (SELECT 1 FROM dbo.Programme WHERE ProgrammeCode = 'DBA')
INSERT INTO dbo.Programme (ProgrammeName, ProgrammeCode)
VALUES ('Diploma in Business Administration', 'DBA');

IF NOT EXISTS (SELECT 1 FROM dbo.Programme WHERE ProgrammeCode = 'DMD')
INSERT INTO dbo.Programme (ProgrammeName, ProgrammeCode)
VALUES ('Diploma in Multimedia Design', 'DMD');
GO

/* LECTURERS */
IF NOT EXISTS (SELECT 1 FROM dbo.Lecturer WHERE Email = 'sarah.lim@college.com')
INSERT INTO dbo.Lecturer (LecturerName, Email, Phone, Password)
VALUES ('Sarah Lim', 'sarah.lim@college.com', '0121112233', '123456');

IF NOT EXISTS (SELECT 1 FROM dbo.Lecturer WHERE Email = 'daniel.tan@college.com')
INSERT INTO dbo.Lecturer (LecturerName, Email, Phone, Password)
VALUES ('Daniel Tan', 'daniel.tan@college.com', '0122223344', '123456');

IF NOT EXISTS (SELECT 1 FROM dbo.Lecturer WHERE Email = 'aisha.rahman@college.com')
INSERT INTO dbo.Lecturer (LecturerName, Email, Phone, Password)
VALUES ('Aisha Rahman', 'aisha.rahman@college.com', '0123334455', '123456');
GO

/* STUDENTS */
DECLARE @DIT INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DIT');
DECLARE @DCS INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DCS');
DECLARE @DBA INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DBA');
DECLARE @DMD INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DMD');

IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE Email = 'alice.lee@student.com')
INSERT INTO dbo.Student (StudentName, Email, Password, ProgrammeID, Phone)
VALUES ('Alice Lee', 'alice.lee@student.com', '123456', @DIT, '0111001001');

IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE Email = 'brandon.wong@student.com')
INSERT INTO dbo.Student (StudentName, Email, Password, ProgrammeID, Phone)
VALUES ('Brandon Wong', 'brandon.wong@student.com', '123456', @DIT, '0111001002');

IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE Email = 'chloe.ng@student.com')
INSERT INTO dbo.Student (StudentName, Email, Password, ProgrammeID, Phone)
VALUES ('Chloe Ng', 'chloe.ng@student.com', '123456', @DCS, '0111001003');

IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE Email = 'devin.raj@student.com')
INSERT INTO dbo.Student (StudentName, Email, Password, ProgrammeID, Phone)
VALUES ('Devin Raj', 'devin.raj@student.com', '123456', @DBA, '0111001004');

IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE Email = 'emma.tan@student.com')
INSERT INTO dbo.Student (StudentName, Email, Password, ProgrammeID, Phone)
VALUES ('Emma Tan', 'emma.tan@student.com', '123456', @DMD, '0111001005');
GO

/* COURSES */
DECLARE @DIT2 INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DIT');
DECLARE @DCS2 INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DCS');
DECLARE @DBA2 INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DBA');
DECLARE @DMD2 INT = (SELECT ProgrammeID FROM dbo.Programme WHERE ProgrammeCode = 'DMD');

IF NOT EXISTS (SELECT 1 FROM dbo.Course WHERE CourseCode = 'DIT103')
INSERT INTO dbo.Course (CourseName, CourseCode, CreditHours, ProgrammeID, CourseFee)
VALUES ('Web Application Development', 'DIT103', 3, @DIT2, 1400.00);

IF NOT EXISTS (SELECT 1 FROM dbo.Course WHERE CourseCode = 'DCS201')
INSERT INTO dbo.Course (CourseName, CourseCode, CreditHours, ProgrammeID, CourseFee)
VALUES ('Data Structures', 'DCS201', 3, @DCS2, 1500.00);

IF NOT EXISTS (SELECT 1 FROM dbo.Course WHERE CourseCode = 'DBA101')
INSERT INTO dbo.Course (CourseName, CourseCode, CreditHours, ProgrammeID, CourseFee)
VALUES ('Principles of Management', 'DBA101', 3, @DBA2, 1100.00);

IF NOT EXISTS (SELECT 1 FROM dbo.Course WHERE CourseCode = 'DMD101')
INSERT INTO dbo.Course (CourseName, CourseCode, CreditHours, ProgrammeID, CourseFee)
VALUES ('Digital Design Fundamentals', 'DMD101', 3, @DMD2, 1350.00);
GO

/* LECTURER COURSE ASSIGNMENTS */
DECLARE @Sarah INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email = 'sarah.lim@college.com');
DECLARE @Daniel INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email = 'daniel.tan@college.com');
DECLARE @Aisha INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email = 'aisha.rahman@college.com');

DECLARE @DIT101 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DIT101');
DECLARE @DIT102 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DIT102');
DECLARE @DIT103 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DIT103');
DECLARE @DCS201 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DCS201');
DECLARE @DBA101 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DBA101');
DECLARE @DMD101 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DMD101');

IF NOT EXISTS (SELECT 1 FROM dbo.LecturerCourse WHERE LecturerID=@Sarah AND CourseID=@DIT101)
INSERT INTO dbo.LecturerCourse (LecturerID, CourseID) VALUES (@Sarah, @DIT101);

IF NOT EXISTS (SELECT 1 FROM dbo.LecturerCourse WHERE LecturerID=@Sarah AND CourseID=@DIT103)
INSERT INTO dbo.LecturerCourse (LecturerID, CourseID) VALUES (@Sarah, @DIT103);

IF NOT EXISTS (SELECT 1 FROM dbo.LecturerCourse WHERE LecturerID=@Daniel AND CourseID=@DIT102)
INSERT INTO dbo.LecturerCourse (LecturerID, CourseID) VALUES (@Daniel, @DIT102);

IF NOT EXISTS (SELECT 1 FROM dbo.LecturerCourse WHERE LecturerID=@Daniel AND CourseID=@DCS201)
INSERT INTO dbo.LecturerCourse (LecturerID, CourseID) VALUES (@Daniel, @DCS201);

IF NOT EXISTS (SELECT 1 FROM dbo.LecturerCourse WHERE LecturerID=@Aisha AND CourseID=@DBA101)
INSERT INTO dbo.LecturerCourse (LecturerID, CourseID) VALUES (@Aisha, @DBA101);

IF NOT EXISTS (SELECT 1 FROM dbo.LecturerCourse WHERE LecturerID=@Aisha AND CourseID=@DMD101)
INSERT INTO dbo.LecturerCourse (LecturerID, CourseID) VALUES (@Aisha, @DMD101);
GO

/* ENROLMENTS */
DECLARE @Alice INT = (SELECT StudentID FROM dbo.Student WHERE Email = 'alice.lee@student.com');
DECLARE @Brandon INT = (SELECT StudentID FROM dbo.Student WHERE Email = 'brandon.wong@student.com');
DECLARE @Chloe INT = (SELECT StudentID FROM dbo.Student WHERE Email = 'chloe.ng@student.com');
DECLARE @Devin INT = (SELECT StudentID FROM dbo.Student WHERE Email = 'devin.raj@student.com');
DECLARE @Emma INT = (SELECT StudentID FROM dbo.Student WHERE Email = 'emma.tan@student.com');

DECLARE @C1 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DIT101');
DECLARE @C2 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DIT102');
DECLARE @C3 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DIT103');
DECLARE @C4 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DCS201');
DECLARE @C5 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DBA101');
DECLARE @C6 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode = 'DMD101');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Alice AND CourseID=@C1)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Alice,@C1,'Enrolled');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Alice AND CourseID=@C2)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Alice,@C2,'Enrolled');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Brandon AND CourseID=@C1)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Brandon,@C1,'Enrolled');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Brandon AND CourseID=@C3)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Brandon,@C3,'Enrolled');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Chloe AND CourseID=@C4)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Chloe,@C4,'Enrolled');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Devin AND CourseID=@C5)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Devin,@C5,'Enrolled');

IF NOT EXISTS (SELECT 1 FROM dbo.Enrolment WHERE StudentID=@Emma AND CourseID=@C6)
INSERT INTO dbo.Enrolment (StudentID, CourseID, Status) VALUES (@Emma,@C6,'Enrolled');
GO

/* SCHEDULES */
DECLARE @LSarah INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email='sarah.lim@college.com');
DECLARE @LDaniel INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email='daniel.tan@college.com');
DECLARE @LAisha INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email='aisha.rahman@college.com');

DECLARE @SC1 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101');
DECLARE @SC2 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT102');
DECLARE @SC3 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT103');
DECLARE @SC4 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DCS201');
DECLARE @SC5 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DBA101');
DECLARE @SC6 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DMD101');

IF NOT EXISTS (SELECT 1 FROM dbo.Schedule WHERE CourseID=@SC1 AND DayOfWeek='Tuesday')
INSERT INTO dbo.Schedule (CourseID,LecturerID,DayOfWeek,StartTime,EndTime,Room)
VALUES (@SC1,@LSarah,'Tuesday','09:00','11:00','Lab A');

IF NOT EXISTS (SELECT 1 FROM dbo.Schedule WHERE CourseID=@SC2 AND DayOfWeek='Wednesday')
INSERT INTO dbo.Schedule (CourseID,LecturerID,DayOfWeek,StartTime,EndTime,Room)
VALUES (@SC2,@LDaniel,'Wednesday','10:00','12:00','Room B12');

IF NOT EXISTS (SELECT 1 FROM dbo.Schedule WHERE CourseID=@SC3 AND DayOfWeek='Thursday')
INSERT INTO dbo.Schedule (CourseID,LecturerID,DayOfWeek,StartTime,EndTime,Room)
VALUES (@SC3,@LSarah,'Thursday','14:00','16:00','Lab C');

IF NOT EXISTS (SELECT 1 FROM dbo.Schedule WHERE CourseID=@SC4 AND DayOfWeek='Friday')
INSERT INTO dbo.Schedule (CourseID,LecturerID,DayOfWeek,StartTime,EndTime,Room)
VALUES (@SC4,@LDaniel,'Friday','09:00','11:00','Room C21');

IF NOT EXISTS (SELECT 1 FROM dbo.Schedule WHERE CourseID=@SC5 AND DayOfWeek='Monday')
INSERT INTO dbo.Schedule (CourseID,LecturerID,DayOfWeek,StartTime,EndTime,Room)
VALUES (@SC5,@LAisha,'Monday','13:00','15:00','Room D10');

IF NOT EXISTS (SELECT 1 FROM dbo.Schedule WHERE CourseID=@SC6 AND DayOfWeek='Wednesday')
INSERT INTO dbo.Schedule (CourseID,LecturerID,DayOfWeek,StartTime,EndTime,Room)
VALUES (@SC6,@LAisha,'Wednesday','15:00','17:00','Design Studio');
GO

/* ASSESSMENTS */
DECLARE @ASarah INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email='sarah.lim@college.com');
DECLARE @ADaniel INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email='daniel.tan@college.com');
DECLARE @AAisha INT = (SELECT LecturerID FROM dbo.Lecturer WHERE Email='aisha.rahman@college.com');

DECLARE @AC1 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101');
DECLARE @AC2 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT102');
DECLARE @AC3 INT = (SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT103');

IF NOT EXISTS (SELECT 1 FROM dbo.Assessment WHERE CourseID=@AC1 AND AssessmentName='Assignment 1')
INSERT INTO dbo.Assessment (CourseID,LecturerID,AssessmentName,MaxMark,Weightage)
VALUES (@AC1,@ASarah,'Assignment 1',100,30);

IF NOT EXISTS (SELECT 1 FROM dbo.Assessment WHERE CourseID=@AC1 AND AssessmentName='Final Exam')
INSERT INTO dbo.Assessment (CourseID,LecturerID,AssessmentName,MaxMark,Weightage)
VALUES (@AC1,@ASarah,'Final Exam',100,70);

IF NOT EXISTS (SELECT 1 FROM dbo.Assessment WHERE CourseID=@AC2 AND AssessmentName='Database Project')
INSERT INTO dbo.Assessment (CourseID,LecturerID,AssessmentName,MaxMark,Weightage)
VALUES (@AC2,@ADaniel,'Database Project',100,40);

IF NOT EXISTS (SELECT 1 FROM dbo.Assessment WHERE CourseID=@AC3 AND AssessmentName='Web Project')
INSERT INTO dbo.Assessment (CourseID,LecturerID,AssessmentName,MaxMark,Weightage)
VALUES (@AC3,@ASarah,'Web Project',100,50);
GO

/* STUDENT MARKS */
DECLARE @Alice2 INT=(SELECT StudentID FROM dbo.Student WHERE Email='alice.lee@student.com');
DECLARE @Brandon2 INT=(SELECT StudentID FROM dbo.Student WHERE Email='brandon.wong@student.com');

DECLARE @A1 INT=(SELECT AssessmentID FROM dbo.Assessment WHERE AssessmentName='Assignment 1' AND CourseID=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101'));
DECLARE @A2 INT=(SELECT AssessmentID FROM dbo.Assessment WHERE AssessmentName='Final Exam' AND CourseID=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101'));
DECLARE @A3 INT=(SELECT AssessmentID FROM dbo.Assessment WHERE AssessmentName='Database Project' AND CourseID=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT102'));
DECLARE @A4 INT=(SELECT AssessmentID FROM dbo.Assessment WHERE AssessmentName='Web Project' AND CourseID=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT103'));

IF @A1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.StudentMark WHERE AssessmentID=@A1 AND StudentID=@Alice2)
INSERT INTO dbo.StudentMark (AssessmentID,StudentID,MarkObtained,Remarks)
VALUES (@A1,@Alice2,82,'Good work');

IF @A2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.StudentMark WHERE AssessmentID=@A2 AND StudentID=@Alice2)
INSERT INTO dbo.StudentMark (AssessmentID,StudentID,MarkObtained,Remarks)
VALUES (@A2,@Alice2,76,'Passed');

IF @A3 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.StudentMark WHERE AssessmentID=@A3 AND StudentID=@Alice2)
INSERT INTO dbo.StudentMark (AssessmentID,StudentID,MarkObtained,Remarks)
VALUES (@A3,@Alice2,88,'Excellent project');

IF @A1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.StudentMark WHERE AssessmentID=@A1 AND StudentID=@Brandon2)
INSERT INTO dbo.StudentMark (AssessmentID,StudentID,MarkObtained,Remarks)
VALUES (@A1,@Brandon2,68,'Satisfactory');

IF @A4 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.StudentMark WHERE AssessmentID=@A4 AND StudentID=@Brandon2)
INSERT INTO dbo.StudentMark (AssessmentID,StudentID,MarkObtained,Remarks)
VALUES (@A4,@Brandon2,91,'Excellent');
GO

/* ATTENDANCE */
DECLARE @StuAlice INT=(SELECT StudentID FROM dbo.Student WHERE Email='alice.lee@student.com');
DECLARE @StuBrandon INT=(SELECT StudentID FROM dbo.Student WHERE Email='brandon.wong@student.com');
DECLARE @LectSarah INT=(SELECT LecturerID FROM dbo.Lecturer WHERE Email='sarah.lim@college.com');
DECLARE @CourseDIT101 INT=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101');

IF NOT EXISTS (SELECT 1 FROM dbo.Attendance WHERE StudentID=@StuAlice AND CourseID=@CourseDIT101 AND AttendanceDate='2026-06-01')
INSERT INTO dbo.Attendance (StudentID,CourseID,LecturerID,AttendanceDate,Status,Remarks)
VALUES (@StuAlice,@CourseDIT101,@LectSarah,'2026-06-01','Present','On time');

IF NOT EXISTS (SELECT 1 FROM dbo.Attendance WHERE StudentID=@StuAlice AND CourseID=@CourseDIT101 AND AttendanceDate='2026-06-08')
INSERT INTO dbo.Attendance (StudentID,CourseID,LecturerID,AttendanceDate,Status,Remarks)
VALUES (@StuAlice,@CourseDIT101,@LectSarah,'2026-06-08','Late','Arrived 10 minutes late');

IF NOT EXISTS (SELECT 1 FROM dbo.Attendance WHERE StudentID=@StuBrandon AND CourseID=@CourseDIT101 AND AttendanceDate='2026-06-01')
INSERT INTO dbo.Attendance (StudentID,CourseID,LecturerID,AttendanceDate,Status,Remarks)
VALUES (@StuBrandon,@CourseDIT101,@LectSarah,'2026-06-01','Present','On time');

IF NOT EXISTS (SELECT 1 FROM dbo.Attendance WHERE StudentID=@StuBrandon AND CourseID=@CourseDIT101 AND AttendanceDate='2026-06-08')
INSERT INTO dbo.Attendance (StudentID,CourseID,LecturerID,AttendanceDate,Status,Remarks)
VALUES (@StuBrandon,@CourseDIT101,@LectSarah,'2026-06-08','Absent','Medical leave');
GO

/* STUDENT FEES */
DECLARE @FAlice INT=(SELECT StudentID FROM dbo.Student WHERE Email='alice.lee@student.com');
DECLARE @FBrandon INT=(SELECT StudentID FROM dbo.Student WHERE Email='brandon.wong@student.com');
DECLARE @FChloe INT=(SELECT StudentID FROM dbo.Student WHERE Email='chloe.ng@student.com');

DECLARE @FC1 INT=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101');
DECLARE @FC2 INT=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT102');
DECLARE @FC3 INT=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT103');
DECLARE @FC4 INT=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DCS201');

IF NOT EXISTS (SELECT 1 FROM dbo.StudentFee WHERE StudentID=@FAlice AND CourseID=@FC1 AND FeeType='Course Fee')
INSERT INTO dbo.StudentFee
(StudentID,CourseID,FeeType,Description,TotalAmount,PaidAmount,DueDate,PaymentStatus)
VALUES (@FAlice,@FC1,'Course Fee','Programming Fundamentals fee',1200,600,'2026-07-15','Partially Paid');

IF NOT EXISTS (SELECT 1 FROM dbo.StudentFee WHERE StudentID=@FAlice AND CourseID=@FC2 AND FeeType='Course Fee')
INSERT INTO dbo.StudentFee
(StudentID,CourseID,FeeType,Description,TotalAmount,PaidAmount,DueDate,PaymentStatus)
VALUES (@FAlice,@FC2,'Course Fee','Database Systems fee',1300,1300,'2026-07-15','Paid');

IF NOT EXISTS (SELECT 1 FROM dbo.StudentFee WHERE StudentID=@FBrandon AND CourseID=@FC3 AND FeeType='Course Fee')
INSERT INTO dbo.StudentFee
(StudentID,CourseID,FeeType,Description,TotalAmount,PaidAmount,DueDate,PaymentStatus)
VALUES (@FBrandon,@FC3,'Course Fee','Web Application Development fee',1400,0,'2026-07-20','Unpaid');

IF NOT EXISTS (SELECT 1 FROM dbo.StudentFee WHERE StudentID=@FChloe AND CourseID=@FC4 AND FeeType='Course Fee')
INSERT INTO dbo.StudentFee
(StudentID,CourseID,FeeType,Description,TotalAmount,PaidAmount,DueDate,PaymentStatus)
VALUES (@FChloe,@FC4,'Course Fee','Data Structures fee',1500,500,'2026-07-20','Partially Paid');
GO

/* PAYMENT HISTORY */
DECLARE @PayAlice INT=(SELECT StudentID FROM dbo.Student WHERE Email='alice.lee@student.com');
DECLARE @FeeAlice1 INT=(
    SELECT TOP 1 FeeID FROM dbo.StudentFee
    WHERE StudentID=@PayAlice
      AND CourseID=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT101')
);
DECLARE @FeeAlice2 INT=(
    SELECT TOP 1 FeeID FROM dbo.StudentFee
    WHERE StudentID=@PayAlice
      AND CourseID=(SELECT CourseID FROM dbo.Course WHERE CourseCode='DIT102')
);

IF @FeeAlice1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.FeePayment WHERE ReferenceNumber='PAY-DUMMY-1001')
INSERT INTO dbo.FeePayment
(FeeID,StudentID,PaymentAmount,PaymentMethod,ReferenceNumber,PaymentDate,PaymentStatus)
VALUES (@FeeAlice1,@PayAlice,600,'Online Banking','PAY-DUMMY-1001','2026-06-10','Successful');

IF @FeeAlice2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.FeePayment WHERE ReferenceNumber='PAY-DUMMY-1002')
INSERT INTO dbo.FeePayment
(FeeID,StudentID,PaymentAmount,PaymentMethod,ReferenceNumber,PaymentDate,PaymentStatus)
VALUES (@FeeAlice2,@PayAlice,1300,'Credit Card','PAY-DUMMY-1002','2026-06-12','Successful');
GO

/* ANNOUNCEMENTS */
IF NOT EXISTS (SELECT 1 FROM dbo.Announcement WHERE Title='Mid-Semester Examination')
INSERT INTO dbo.Announcement
(Title,Message,Audience,CreatedByRole,CreatedByID,ExpiryDate,IsActive)
VALUES
('Mid-Semester Examination',
 'The mid-semester examination timetable is now available.',
 'Student','Admin',NULL,'2026-08-01',1);

IF NOT EXISTS (SELECT 1 FROM dbo.Announcement WHERE Title='Lecturer Meeting')
INSERT INTO dbo.Announcement
(Title,Message,Audience,CreatedByRole,CreatedByID,ExpiryDate,IsActive)
VALUES
('Lecturer Meeting',
 'All lecturers are required to attend the academic meeting.',
 'Lecturer','Admin',NULL,'2026-07-10',1);
GO

/* ACADEMIC CALENDAR */
IF NOT EXISTS (SELECT 1 FROM dbo.AcademicCalendar WHERE EventTitle='Mid-Semester Break')
INSERT INTO dbo.AcademicCalendar
(EventTitle,EventDescription,EventType,StartDate,EndDate,Audience,Location,CreatedByRole,IsActive)
VALUES
('Mid-Semester Break',
 'One-week semester break for all students.',
 'Holiday',
 '2026-08-17','2026-08-23','All','College Campus','Admin',1);

IF NOT EXISTS (SELECT 1 FROM dbo.AcademicCalendar WHERE EventTitle='Final Examination')
INSERT INTO dbo.AcademicCalendar
(EventTitle,EventDescription,EventType,StartDate,EndDate,Audience,Location,CreatedByRole,IsActive)
VALUES
('Final Examination',
 'Final examination period.',
 'Examination',
 '2026-10-05','2026-10-16','Student','Examination Hall','Admin',1);
GO

/* VERIFY DATA */
SELECT 'Students' AS TableName, COUNT(*) AS TotalRows FROM dbo.Student
UNION ALL
SELECT 'Lecturers', COUNT(*) FROM dbo.Lecturer
UNION ALL
SELECT 'Courses', COUNT(*) FROM dbo.Course
UNION ALL
SELECT 'Enrolments', COUNT(*) FROM dbo.Enrolment
UNION ALL
SELECT 'Schedules', COUNT(*) FROM dbo.Schedule
UNION ALL
SELECT 'Assessments', COUNT(*) FROM dbo.Assessment
UNION ALL
SELECT 'Student Marks', COUNT(*) FROM dbo.StudentMark
UNION ALL
SELECT 'Attendance', COUNT(*) FROM dbo.Attendance
UNION ALL
SELECT 'Student Fees', COUNT(*) FROM dbo.StudentFee
UNION ALL
SELECT 'Payments', COUNT(*) FROM dbo.FeePayment;
GO
