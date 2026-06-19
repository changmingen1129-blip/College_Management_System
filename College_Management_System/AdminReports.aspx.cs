using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class AdminReports : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect(
                    ResolveUrl("~/Login.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadSummaryCards();
                    LoadProgrammeFilter();
                    LoadCourseFilter(0);
                    LoadAllReports(0, 0);
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load the reports. " + ex.Message,
                        "error"
                    );
                }
            }
        }

        private void LoadSummaryCards()
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    (SELECT COUNT(*) FROM Student)
                        AS TotalStudents,

                    (SELECT COUNT(*) FROM Lecturer)
                        AS TotalLecturers,

                    (SELECT COUNT(*) FROM Programme)
                        AS TotalProgrammes,

                    (SELECT COUNT(*) FROM Course)
                        AS TotalCourses";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalStudents.Text =
                                reader["TotalStudents"].ToString();

                            lblTotalLecturers.Text =
                                reader["TotalLecturers"].ToString();

                            lblTotalProgrammes.Text =
                                reader["TotalProgrammes"].ToString();

                            lblTotalCourses.Text =
                                reader["TotalCourses"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadProgrammeFilter()
        {
            ddlProgramme.Items.Clear();

            ddlProgramme.Items.Add(
                new ListItem(
                    "All Programmes",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    ProgrammeID,
                    ProgrammeCode,
                    ProgrammeName
                FROM Programme
                ORDER BY
                    ProgrammeCode,
                    ProgrammeName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string displayText =
                                reader["ProgrammeCode"].ToString()
                                + " - "
                                + reader["ProgrammeName"].ToString();

                            ddlProgramme.Items.Add(
                                new ListItem(
                                    displayText,
                                    reader["ProgrammeID"].ToString()
                                )
                            );
                        }
                    }
                }
            }
        }

        private void LoadCourseFilter(int programmeID)
        {
            ddlCourse.Items.Clear();

            ddlCourse.Items.Add(
                new ListItem(
                    "All Courses",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    CourseID,
                    CourseCode,
                    CourseName
                FROM Course
                WHERE
                    @ProgrammeID = 0
                    OR ProgrammeID = @ProgrammeID
                ORDER BY
                    CourseCode,
                    CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@ProgrammeID",
                        SqlDbType.Int
                    ).Value = programmeID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string displayText =
                                reader["CourseCode"].ToString()
                                + " - "
                                + reader["CourseName"].ToString();

                            ddlCourse.Items.Add(
                                new ListItem(
                                    displayText,
                                    reader["CourseID"].ToString()
                                )
                            );
                        }
                    }
                }
            }
        }

        protected void ddlProgramme_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            HideMessage();

            int programmeID;

            if (!int.TryParse(
                ddlProgramme.SelectedValue,
                out programmeID))
            {
                programmeID = 0;
            }

            try
            {
                LoadCourseFilter(programmeID);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load courses. " + ex.Message,
                    "error"
                );
            }
        }

        protected void btnLoadReports_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            int programmeID;
            int courseID;

            if (!int.TryParse(
                ddlProgramme.SelectedValue,
                out programmeID))
            {
                programmeID = 0;
            }

            if (!int.TryParse(
                ddlCourse.SelectedValue,
                out courseID))
            {
                courseID = 0;
            }

            try
            {
                LoadAllReports(
                    programmeID,
                    courseID
                );

                ShowMessage(
                    "Reports loaded successfully.",
                    "success"
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load the reports. " + ex.Message,
                    "error"
                );
            }
        }

        protected void btnResetFilters_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            try
            {
                ddlProgramme.SelectedValue = "0";

                LoadCourseFilter(0);

                ddlCourse.SelectedValue = "0";

                LoadAllReports(0, 0);

                ShowMessage(
                    "Report filters have been reset.",
                    "success"
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to reset the reports. " + ex.Message,
                    "error"
                );
            }
        }

        private void LoadAllReports(
            int programmeID,
            int courseID)
        {
            LoadEnrolmentReport(programmeID);

            LoadAttendanceReport(
                programmeID,
                courseID
            );

            LoadPerformanceReport(
                programmeID,
                courseID
            );

            LoadRiskReport(
                programmeID,
                courseID
            );
        }

        private void LoadEnrolmentReport(
            int programmeID)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    p.ProgrammeID,
                    p.ProgrammeCode,
                    p.ProgrammeName,

                    COUNT
                    (
                        DISTINCT s.StudentID
                    ) AS TotalStudents,

                    COUNT
                    (
                        CASE
                            WHEN ISNULL(e.Status, '') IN
                            (
                                'Enrolled',
                                'Approved',
                                'Active'
                            )
                            THEN e.EnrolmentID
                        END
                    ) AS ActiveEnrolments,

                    COUNT
                    (
                        CASE
                            WHEN ISNULL(e.Status, '') =
                                 'Dropped'
                            THEN e.EnrolmentID
                        END
                    ) AS DroppedEnrolments

                FROM Programme p

                LEFT JOIN Student s
                    ON p.ProgrammeID =
                       s.ProgrammeID

                LEFT JOIN Enrolment e
                    ON s.StudentID =
                       e.StudentID

                WHERE
                    @ProgrammeID = 0
                    OR p.ProgrammeID =
                       @ProgrammeID

                GROUP BY
                    p.ProgrammeID,
                    p.ProgrammeCode,
                    p.ProgrammeName

                ORDER BY
                    p.ProgrammeCode,
                    p.ProgrammeName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@ProgrammeID",
                        SqlDbType.Int
                    ).Value = programmeID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            gvEnrolmentReport.DataSource =
                table;

            gvEnrolmentReport.DataBind();
        }

        private void LoadAttendanceReport(
            int programmeID,
            int courseID)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName,

                    COUNT(a.AttendanceID)
                        AS TotalAttendanceRecords,

                    ISNULL
                    (
                        SUM
                        (
                            CASE
                                WHEN a.Status IN
                                (
                                    'Present',
                                    'Late'
                                )
                                THEN 1
                                ELSE 0
                            END
                        ),
                        0
                    ) AS PresentRecords,

                    ISNULL
                    (
                        SUM
                        (
                            CASE
                                WHEN a.Status = 'Absent'
                                THEN 1
                                ELSE 0
                            END
                        ),
                        0
                    ) AS AbsentRecords,

                    CAST
                    (
                        CASE
                            WHEN COUNT(a.AttendanceID) = 0
                            THEN 0

                            ELSE
                            (
                                CAST
                                (
                                    ISNULL
                                    (
                                        SUM
                                        (
                                            CASE
                                                WHEN a.Status IN
                                                (
                                                    'Present',
                                                    'Late'
                                                )
                                                THEN 1
                                                ELSE 0
                                            END
                                        ),
                                        0
                                    )
                                    AS DECIMAL(10,2)
                                )
                                /
                                COUNT(a.AttendanceID)
                            ) * 100
                        END
                        AS DECIMAL(6,2)
                    ) AS AttendancePercentage

                FROM Course c

                LEFT JOIN Attendance a
                    ON c.CourseID =
                       a.CourseID

                WHERE
                    (
                        @ProgrammeID = 0
                        OR c.ProgrammeID =
                           @ProgrammeID
                    )

                    AND
                    (
                        @CourseID = 0
                        OR c.CourseID =
                           @CourseID
                    )

                GROUP BY
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName

                ORDER BY
                    c.CourseCode,
                    c.CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@ProgrammeID",
                        SqlDbType.Int
                    ).Value = programmeID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            gvAttendanceReport.DataSource =
                table;

            gvAttendanceReport.DataBind();
        }

        private void LoadPerformanceReport(
            int programmeID,
            int courseID)
        {
            DataTable sourceTable =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName,
                    sm.StudentID,

                    CAST
                    (
                        SUM
                        (
                            CASE
                                WHEN ass.MaxMark = 0
                                THEN 0

                                ELSE
                                (
                                    sm.MarkObtained
                                    /
                                    ass.MaxMark
                                )
                                * ass.Weightage
                            END
                        )
                        AS DECIMAL(6,2)
                    ) AS FinalPercentage

                FROM Course c

                INNER JOIN Assessment ass
                    ON c.CourseID =
                       ass.CourseID

                INNER JOIN StudentMark sm
                    ON ass.AssessmentID =
                       sm.AssessmentID

                WHERE
                    (
                        @ProgrammeID = 0
                        OR c.ProgrammeID =
                           @ProgrammeID
                    )

                    AND
                    (
                        @CourseID = 0
                        OR c.CourseID =
                           @CourseID
                    )

                GROUP BY
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName,
                    sm.StudentID

                ORDER BY
                    c.CourseCode,
                    sm.StudentID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@ProgrammeID",
                        SqlDbType.Int
                    ).Value = programmeID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(sourceTable);
                    }
                }
            }

            DataTable reportTable =
                CreatePerformanceSummary(
                    sourceTable
                );

            gvPerformanceReport.DataSource =
                reportTable;

            gvPerformanceReport.DataBind();
        }

        private DataTable CreatePerformanceSummary(
            DataTable sourceTable)
        {
            DataTable resultTable =
                new DataTable();

            resultTable.Columns.Add(
                "CourseID",
                typeof(int)
            );

            resultTable.Columns.Add(
                "CourseCode",
                typeof(string)
            );

            resultTable.Columns.Add(
                "CourseName",
                typeof(string)
            );

            resultTable.Columns.Add(
                "StudentsWithMarks",
                typeof(int)
            );

            resultTable.Columns.Add(
                "AverageMarkPercentage",
                typeof(decimal)
            );

            resultTable.Columns.Add(
                "PassedStudents",
                typeof(int)
            );

            resultTable.Columns.Add(
                "FailedStudents",
                typeof(int)
            );

            if (sourceTable.Rows.Count == 0)
            {
                return resultTable;
            }

            DataView courseView =
                new DataView(sourceTable);

            DataTable distinctCourses =
                courseView.ToTable(
                    true,
                    "CourseID",
                    "CourseCode",
                    "CourseName"
                );

            foreach (DataRow courseRow
                in distinctCourses.Rows)
            {
                int currentCourseID =
                    Convert.ToInt32(
                        courseRow["CourseID"]
                    );

                DataRow[] studentRows =
                    sourceTable.Select(
                        "CourseID = "
                        + currentCourseID
                    );

                int studentsWithMarks =
                    studentRows.Length;

                decimal totalPercentage = 0;
                int passedStudents = 0;
                int failedStudents = 0;

                foreach (DataRow studentRow
                    in studentRows)
                {
                    decimal finalPercentage =
                        Convert.ToDecimal(
                            studentRow[
                                "FinalPercentage"
                            ]
                        );

                    totalPercentage +=
                        finalPercentage;

                    if (finalPercentage >= 50)
                    {
                        passedStudents++;
                    }
                    else
                    {
                        failedStudents++;
                    }
                }

                decimal averagePercentage = 0;

                if (studentsWithMarks > 0)
                {
                    averagePercentage =
                        totalPercentage
                        / studentsWithMarks;
                }

                DataRow resultRow =
                    resultTable.NewRow();

                resultRow["CourseID"] =
                    currentCourseID;

                resultRow["CourseCode"] =
                    courseRow["CourseCode"];

                resultRow["CourseName"] =
                    courseRow["CourseName"];

                resultRow["StudentsWithMarks"] =
                    studentsWithMarks;

                resultRow["AverageMarkPercentage"] =
                    Math.Round(
                        averagePercentage,
                        2
                    );

                resultRow["PassedStudents"] =
                    passedStudents;

                resultRow["FailedStudents"] =
                    failedStudents;

                resultTable.Rows.Add(
                    resultRow
                );
            }

            return resultTable;
        }

        private void LoadRiskReport(
            int programmeID,
            int courseID)
        {
            DataTable sourceTable =
                GetRiskSourceData(
                    programmeID,
                    courseID
                );

            DataTable riskTable =
                CreateRiskTable(
                    sourceTable
                );

            gvRiskReport.DataSource =
                riskTable;

            gvRiskReport.DataBind();
        }

        private DataTable GetRiskSourceData(
            int programmeID,
            int courseID)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    s.StudentID,
                    s.StudentName,
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName,

                    ISNULL
                    (
                        attendanceSummary.TotalRecords,
                        0
                    ) AS TotalAttendanceRecords,

                    CAST
                    (
                        CASE
                            WHEN ISNULL
                            (
                                attendanceSummary.TotalRecords,
                                0
                            ) = 0
                            THEN 0

                            ELSE
                            (
                                CAST
                                (
                                    ISNULL
                                    (
                                        attendanceSummary.AttendedRecords,
                                        0
                                    )
                                    AS DECIMAL(10,2)
                                )
                                /
                                attendanceSummary.TotalRecords
                            ) * 100
                        END
                        AS DECIMAL(6,2)
                    ) AS AttendancePercentage,

                    ISNULL
                    (
                        performanceSummary.AssessmentCount,
                        0
                    ) AS AssessmentCount,

                    CAST
                    (
                        ISNULL
                        (
                            performanceSummary.FinalPercentage,
                            0
                        )
                        AS DECIMAL(6,2)
                    ) AS AverageMarkPercentage

                FROM Enrolment e

                INNER JOIN Student s
                    ON e.StudentID =
                       s.StudentID

                INNER JOIN Course c
                    ON e.CourseID =
                       c.CourseID

                OUTER APPLY
                (
                    SELECT
                        COUNT(*) AS TotalRecords,

                        ISNULL
                        (
                            SUM
                            (
                                CASE
                                    WHEN a.Status IN
                                    (
                                        'Present',
                                        'Late'
                                    )
                                    THEN 1
                                    ELSE 0
                                END
                            ),
                            0
                        ) AS AttendedRecords

                    FROM Attendance a

                    WHERE a.StudentID =
                          s.StudentID

                      AND a.CourseID =
                          c.CourseID
                ) AS attendanceSummary

                OUTER APPLY
                (
                    SELECT
                        COUNT(*) AS AssessmentCount,

                        ISNULL
                        (
                            SUM
                            (
                                CASE
                                    WHEN ass.MaxMark = 0
                                    THEN 0

                                    ELSE
                                    (
                                        sm.MarkObtained
                                        /
                                        ass.MaxMark
                                    )
                                    * ass.Weightage
                                END
                            ),
                            0
                        ) AS FinalPercentage

                    FROM StudentMark sm

                    INNER JOIN Assessment ass
                        ON sm.AssessmentID =
                           ass.AssessmentID

                    WHERE sm.StudentID =
                          s.StudentID

                      AND ass.CourseID =
                          c.CourseID
                ) AS performanceSummary

                WHERE ISNULL(e.Status, '') IN
                      (
                          'Enrolled',
                          'Approved',
                          'Active'
                      )

                  AND
                  (
                      @ProgrammeID = 0
                      OR c.ProgrammeID =
                         @ProgrammeID
                  )

                  AND
                  (
                      @CourseID = 0
                      OR c.CourseID =
                         @CourseID
                  )

                ORDER BY
                    s.StudentName,
                    c.CourseCode";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@ProgrammeID",
                        SqlDbType.Int
                    ).Value = programmeID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            return table;
        }

        private DataTable CreateRiskTable(
            DataTable sourceTable)
        {
            DataTable resultTable =
                sourceTable.Clone();

            resultTable.Columns.Add(
                "RiskLevel",
                typeof(string)
            );

            resultTable.Columns.Add(
                "RiskReason",
                typeof(string)
            );

            foreach (DataRow sourceRow
                in sourceTable.Rows)
            {
                decimal attendancePercentage =
                    Convert.ToDecimal(
                        sourceRow[
                            "AttendancePercentage"
                        ]
                    );

                decimal markPercentage =
                    Convert.ToDecimal(
                        sourceRow[
                            "AverageMarkPercentage"
                        ]
                    );

                int attendanceRecords =
                    Convert.ToInt32(
                        sourceRow[
                            "TotalAttendanceRecords"
                        ]
                    );

                int assessmentCount =
                    Convert.ToInt32(
                        sourceRow[
                            "AssessmentCount"
                        ]
                    );

                bool lowAttendance =
                    attendanceRecords > 0
                    && attendancePercentage < 80;

                bool lowPerformance =
                    assessmentCount > 0
                    && markPercentage < 50;

                if (!lowAttendance
                    && !lowPerformance)
                {
                    continue;
                }

                string riskLevel;
                string riskReason;

                if (lowAttendance
                    && lowPerformance)
                {
                    riskLevel = "High Risk";

                    riskReason =
                        "Attendance is below 80 percent and academic performance is below 50 percent.";
                }
                else if (lowAttendance)
                {
                    riskLevel = "Warning";

                    riskReason =
                        "Attendance is below the required 80 percent.";
                }
                else
                {
                    riskLevel = "Warning";

                    riskReason =
                        "Academic performance is below 50 percent.";
                }

                DataRow resultRow =
                    resultTable.NewRow();

                foreach (DataColumn column
                    in sourceTable.Columns)
                {
                    resultRow[column.ColumnName] =
                        sourceRow[column.ColumnName];
                }

                resultRow["RiskLevel"] =
                    riskLevel;

                resultRow["RiskReason"] =
                    riskReason;

                resultTable.Rows.Add(
                    resultRow
                );
            }

            return resultTable;
        }

        public string GetRiskClass(
            string riskLevel)
        {
            if (riskLevel == "Good Standing")
            {
                return
                    "status-badge status-good";
            }

            if (riskLevel == "Warning")
            {
                return
                    "status-badge status-warning";
            }

            return
                "status-badge status-risk";
        }

        private void ShowMessage(
            string message,
            string type)
        {
            lblMessage.Visible = true;
            lblMessage.Text = message;

            if (type == "success")
            {
                lblMessage.CssClass =
                    "message-label alert alert-success";
            }
            else if (type == "warning")
            {
                lblMessage.CssClass =
                    "message-label alert alert-warning";
            }
            else
            {
                lblMessage.CssClass =
                    "message-label alert alert-danger";
            }
        }

        private void HideMessage()
        {
            lblMessage.Visible = false;
            lblMessage.Text = "";
        }
    }


}
