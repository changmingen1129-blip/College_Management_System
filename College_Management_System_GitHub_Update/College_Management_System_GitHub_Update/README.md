# College Management System

A web-based College Management System developed with ASP.NET Web Forms, C#, ADO.NET, Visual Studio and Microsoft SQL Server. The application supports separate administrator, lecturer and student portals and stores all academic and administrative information in one relational database.

## Main Features

### Administrator Portal
- Secure administrator login and dashboard
- Programme and course management
- Student and lecturer registration
- Lecturer-course assignment
- Student enrolment and schedule management
- Announcements and academic calendar
- Student fee management
- Attendance, result and institutional reports
- Browser-based print / save as PDF

### Lecturer Portal
- Lecturer login and profile
- Assigned courses and student lists
- Timetable and daily attendance
- Assessment and mark management
- Academic progress monitoring
- Good Standing, Warning and High Risk classification
- Announcements and academic calendar

### Student Portal
- Student login and profile
- View enrolled courses and timetable
- Enrol in or drop courses
- View attendance and academic results
- View GPA / CGPA information
- View fees, payments and outstanding balances
- View announcements and academic calendar

## Technology Stack

- Frontend: ASP.NET Web Forms, HTML, CSS and JavaScript
- Backend: C# and .NET Framework
- Data Access: ADO.NET / `System.Data.SqlClient`
- Database: Microsoft SQL Server LocalDB or SQL Server Express
- IDE: Microsoft Visual Studio 2022
- Database Tool: SQL Server Management Studio (SSMS)
- Version Control: Git and GitHub

## Project Structure

```text
College_Management_System/
├── College_Management_System.slnx
├── College_Management_System/
│   ├── *.aspx
│   ├── *.aspx.cs
│   ├── *.master
│   ├── Web.config
│   └── College_Management_System.csproj
├── Database/
│   ├── CollegeManagementDB.sql
│   ├── CollegeManagementDummyData.sql
│   └── CollegeManagementProgressTestData.sql
└── README.md
```

## System Requirements

- Windows 10 or Windows 11
- Visual Studio 2022 with the **ASP.NET and web development** workload
- .NET Framework 4.8 development tools
- SQL Server LocalDB or SQL Server Express
- SQL Server Management Studio

## Installation and Setup

### 1. Clone the repository

```bash
git clone https://github.com/changmingen1129-blip/College_Management_System.git
cd College_Management_System
```

Alternatively, select **Code > Download ZIP** on GitHub and extract the files.

### 2. Create the database

Open SQL Server Management Studio and connect to:

```text
(localdb)\MSSQLLocalDB
```

Run the scripts in this order:

1. `Database/CollegeManagementDB.sql`
2. `Database/CollegeManagementDummyData.sql`
3. `Database/CollegeManagementProgressTestData.sql` (optional, for the Lecturer Progress demonstration)

The scripts create and populate:

```text
CollegeManagementDB
```

### 3. Configure the connection string

Open `College_Management_System/Web.config` and confirm that the `DBCS` connection string is:

```xml
<connectionStrings>
  <add name="DBCS"
       connectionString="Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CollegeManagementDB;Integrated Security=True"
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

When using SQL Server Express, replace the data source with the correct local instance, for example:

```text
.\SQLEXPRESS
```

### 4. Open and run the project

1. Open `College_Management_System.slnx` in Visual Studio 2022.
2. Restore any required NuGet packages.
3. Right-click the web project and select **Set as Startup Project**.
4. Build the solution using **Build > Rebuild Solution**.
5. Run the application using IIS Express.
6. Open the required Admin, Lecturer or Student login page.

## Demonstration Accounts

These accounts are local academic demonstration accounts only.

| Role | Email | Password |
|---|---|---|
| Administrator | `admin@college.com` | `admin123` |
| Lecturer | `lecturer@college.com` | `123456` |
| Student | `student@college.com` | `123456` |
| Dummy Lecturer | `sarah.lim@college.com` | `123456` |
| Dummy Student | `alice.lee@student.com` | `123456` |

## Team Responsibilities

| Team Member | Responsibility |
|---|---|
| Damion Sim Jian Liang | System integration, database, shared features, testing and documentation |
| Chang Ming En | Administrator module |
| Jason Yeap Yi Zhe | Lecturer module |
| Wong Pin Fung | Student module |

## Current Limitations

- Passwords are stored as plain text in the academic prototype and must be replaced with secure salted password hashing before production use.
- Direct CSV and Excel export are not implemented; reports can be printed or saved as PDF through the browser.
- Complete semester-based academic history and CGPA require additional semester entities.
- Course enrolment does not yet validate prerequisites, capacity, registration periods, credit limits or timetable clashes.
- Email and push notifications are not implemented.
- The current Web Forms code-behind should be refactored into separate business and data-access layers for better maintainability.

## Database Script Notes

- `CollegeManagementDB.sql` creates the database, tables, relationships, constraints and initial accounts.
- `CollegeManagementDummyData.sql` inserts programmes, courses, students, lecturers, schedules, assessments, marks, fees and payments.
- `CollegeManagementProgressTestData.sql` prepares controlled Good Standing, Warning and High Risk progress data.

## Security Notice

The listed credentials are dummy local test accounts. Do not use these passwords for real accounts, and do not commit real passwords, API keys or private connection credentials to the repository.

## Repository

Project repository: `https://github.com/changmingen1129-blip/College_Management_System`
