using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class LecturerProgress : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LecturerID"] == null)
            {
                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            int lecturerID;

            if (!int.TryParse(
                Session["LecturerID"].ToString(),
                out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignedCourses(lecturerID);
                ClearProgressTable();
            }
        }

        private void LoadAssignedCourses(int lecturerID)
        {
            ddlCourse.Items.Clear();

            ddlCourse.Items.Add(
                new ListItem(
                    "-- Select Assigned Course --",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName
                FROM LecturerCourse lc

                INNER JOIN Course c
                    ON lc.CourseID = c.CourseID

                WHERE lc.LecturerID = @LecturerID

                ORDER BY
                    c.CourseCode,
                    c.CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

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

                            string courseID =
                                reader["CourseID"].ToString();

                            ddlCourse.Items.Add(
                                new ListItem(
                                    displayText,
                                    courseID
                                )
                            );
                        }
                    }
                }
            }
        }

        protected void btnLoadProgress_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            int lecturerID;

            if (!TryGetLecturerID(out lecturerID))
            {
                return;
            }

            int courseID;

            if (!int.TryParse(
                ddlCourse.SelectedValue,
                out courseID)
                || courseID <= 0)
            {
                ClearProgressTable();

                ShowMessage(
                    "Please select an assigned course.",
                    "warning"
                );

                return;
            }

            if (!LecturerOwnsCourse(
                lecturerID,
                courseID))
            {
                ClearProgressTable();

                ShowMessage(
                    "You are not assigned to the selected course.",
                    "error"
                );

                return;
            }

            LoadProgressRecords(
                lecturerID,
                courseID
            );
        }

        private void LoadProgressRecords(
            int lecturerID,
            int courseID)
        {
            DataTable sourceTable =
                GetStudentProgressData(
                    lecturerID,
                    courseID
                );

            DataTable progressTable =
                CreateProgressTable(
                    sourceTable
                );

            gvProgress.DataSource =
                progressTable;

            gvProgress.DataBind();

            UpdateSummaryCards(
                progressTable
            );

            if (progressTable.Rows.Count == 0)
            {
                ShowMessage(
                    "No active enrolled students were found for this course.",
                    "warning"
                );
            }
            else
            {
                ShowMessage(
                    "Student progress loaded successfully.",
                    "success"
                );
            }
        }

        private DataTable GetStudentProgressData(
            int lecturerID,
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
                        attendanceSummary.TotalAttendanceRecords,
                        0
                    ) AS TotalAttendanceRecords,

                    ISNULL
                    (
                        attendanceSummary.AttendedRecords,
                        0
                    ) AS AttendedRecords,

                    CAST
                    (
                        CASE
                            WHEN ISNULL
                            (
                                attendanceSummary.TotalAttendanceRecords,
                                0
                            ) = 0
                            THEN 0

                            ELSE
                            (
                                CAST
                                (
                                    attendanceSummary.AttendedRecords
                                    AS DECIMAL(10,2)
                                )
                                /
                                attendanceSummary.TotalAttendanceRecords
                            ) * 100
                        END
                        AS DECIMAL(6,2)
                    ) AS AttendancePercentage,

                    ISNULL
                    (
                        markSummary.AssessmentCount,
                        0
                    ) AS AssessmentCount,

                    CAST
                    (
                        ISNULL
                        (
                            markSummary.AverageMarkPercentage,
                            0
                        )
                        AS DECIMAL(6,2)
                    ) AS AverageMarkPercentage

                FROM Enrolment e

                INNER JOIN Student s
                    ON e.StudentID = s.StudentID

                INNER JOIN Course c
                    ON e.CourseID = c.CourseID

                INNER JOIN LecturerCourse lc
                    ON lc.CourseID = c.CourseID
                   AND lc.LecturerID = @LecturerID

                OUTER APPLY
                (
                    SELECT
                        COUNT(*) AS TotalAttendanceRecords,

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
                        ) AS AttendedRecords

                    FROM Attendance a

                    WHERE a.StudentID =
                          s.StudentID

                      AND a.CourseID =
                          c.CourseID

                      AND a.LecturerID =
                          @LecturerID
                ) AS attendanceSummary

                OUTER APPLY
                (
                    SELECT
                        COUNT(*) AS AssessmentCount,

                        AVG
                        (
                            CASE
                                WHEN ass.MaxMark = 0
                                THEN 0

                                ELSE
                                (
                                    sm.MarkObtained
                                    /
                                    ass.MaxMark
                                ) * 100
                            END
                        ) AS AverageMarkPercentage

                    FROM StudentMark sm

                    INNER JOIN Assessment ass
                        ON sm.AssessmentID =
                           ass.AssessmentID

                    WHERE sm.StudentID =
                          s.StudentID

                      AND ass.CourseID =
                          c.CourseID

                      AND ass.LecturerID =
                          @LecturerID
                ) AS markSummary

                WHERE e.CourseID =
                      @CourseID

                  AND ISNULL(e.Status, '') IN
                      (
                          'Enrolled',
                          'Approved',
                          'Active'
                      )

                ORDER BY
                    s.StudentName,
                    s.StudentID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

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

        private DataTable CreateProgressTable(
            DataTable sourceTable)
        {
            DataTable resultTable =
                new DataTable();

            resultTable.Columns.Add(
                "StudentID",
                typeof(int)
            );

            resultTable.Columns.Add(
                "StudentName",
                typeof(string)
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
                "AttendancePercentage",
                typeof(decimal)
            );

            resultTable.Columns.Add(
                "AverageMarkPercentage",
                typeof(decimal)
            );

            resultTable.Columns.Add(
                "RiskLevel",
                typeof(string)
            );

            resultTable.Columns.Add(
                "WarningReason",
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

                decimal averageMarkPercentage =
                    Convert.ToDecimal(
                        sourceRow[
                            "AverageMarkPercentage"
                        ]
                    );

                int totalAttendanceRecords =
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

                string riskLevel =
                    DetermineRiskLevel(
                        attendancePercentage,
                        averageMarkPercentage,
                        totalAttendanceRecords,
                        assessmentCount
                    );

                string warningReason =
                    DetermineWarningReason(
                        attendancePercentage,
                        averageMarkPercentage,
                        totalAttendanceRecords,
                        assessmentCount
                    );

                DataRow resultRow =
                    resultTable.NewRow();

                resultRow["StudentID"] =
                    sourceRow["StudentID"];

                resultRow["StudentName"] =
                    sourceRow["StudentName"];

                resultRow["CourseCode"] =
                    sourceRow["CourseCode"];

                resultRow["CourseName"] =
                    sourceRow["CourseName"];

                resultRow["AttendancePercentage"] =
                    attendancePercentage;

                resultRow["AverageMarkPercentage"] =
                    averageMarkPercentage;

                resultRow["RiskLevel"] =
                    riskLevel;

                resultRow["WarningReason"] =
                    warningReason;

                resultTable.Rows.Add(
                    resultRow
                );
            }

            return resultTable;
        }

        private string DetermineRiskLevel(
            decimal attendancePercentage,
            decimal averageMarkPercentage,
            int totalAttendanceRecords,
            int assessmentCount)
        {
            bool hasAttendance =
                totalAttendanceRecords > 0;

            bool hasMarks =
                assessmentCount > 0;

            bool lowAttendance =
                hasAttendance
                && attendancePercentage < 80;

            bool lowPerformance =
                hasMarks
                && averageMarkPercentage < 50;

            if (
                lowAttendance
                && lowPerformance
            )
            {
                return "High Risk";
            }

            if (
                lowAttendance
                || lowPerformance
            )
            {
                return "Warning";
            }

            return "Good Standing";
        }

        private string DetermineWarningReason(
            decimal attendancePercentage,
            decimal averageMarkPercentage,
            int totalAttendanceRecords,
            int assessmentCount)
        {
            bool hasAttendance =
                totalAttendanceRecords > 0;

            bool hasMarks =
                assessmentCount > 0;

            bool lowAttendance =
                hasAttendance
                && attendancePercentage < 80;

            bool lowPerformance =
                hasMarks
                && averageMarkPercentage < 50;

            if (
                !hasAttendance
                && !hasMarks
            )
            {
                return
                    "No attendance or assessment records available yet.";
            }

            if (
                lowAttendance
                && lowPerformance
            )
            {
                return
                    "Attendance is below 80 percent and average performance is below 50 percent.";
            }

            if (lowAttendance)
            {
                return
                    "Attendance is below the required 80 percent.";
            }

            if (lowPerformance)
            {
                return
                    "Average assessment performance is below 50 percent.";
            }

            if (!hasAttendance)
            {
                return
                    "No attendance records available. Assessment performance is satisfactory.";
            }

            if (!hasMarks)
            {
                return
                    "No assessment marks available. Attendance is satisfactory.";
            }

            return
                "Attendance and assessment performance are satisfactory.";
        }

        private void UpdateSummaryCards(
            DataTable progressTable)
        {
            int totalStudents =
                progressTable.Rows.Count;

            int goodStanding = 0;
            int warningStudents = 0;
            int highRiskStudents = 0;

            foreach (DataRow row
                in progressTable.Rows)
            {
                string riskLevel =
                    row["RiskLevel"].ToString();

                if (riskLevel == "Good Standing")
                {
                    goodStanding++;
                }
                else if (riskLevel == "Warning")
                {
                    warningStudents++;
                }
                else if (riskLevel == "High Risk")
                {
                    highRiskStudents++;
                }
            }

            lblTotalStudents.Text =
                totalStudents.ToString();

            lblGoodStanding.Text =
                goodStanding.ToString();

            lblWarningStudents.Text =
                warningStudents.ToString();

            lblHighRiskStudents.Text =
                highRiskStudents.ToString();
        }

        private bool LecturerOwnsCourse(
            int lecturerID,
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT COUNT(*)
                FROM LecturerCourse
                WHERE LecturerID =
                      @LecturerID
                  AND CourseID =
                      @CourseID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

                    con.Open();

                    int count =
                        Convert.ToInt32(
                            cmd.ExecuteScalar()
                        );

                    return count > 0;
                }
            }
        }

        private bool TryGetLecturerID(
            out int lecturerID)
        {
            lecturerID = 0;

            if (Session["LecturerID"] == null)
            {
                Response.Redirect(
                    "LecturerLogin.aspx"
                );

                return false;
            }

            if (!int.TryParse(
                Session["LecturerID"].ToString(),
                out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect(
                    "LecturerLogin.aspx"
                );

                return false;
            }

            return true;
        }

        public string GetRiskClass(
            string riskLevel)
        {
            if (riskLevel == "Good Standing")
            {
                return
                    "risk-badge risk-good";
            }

            if (riskLevel == "Warning")
            {
                return
                    "risk-badge risk-warning";
            }

            return
                "risk-badge risk-high";
        }

        private void ClearProgressTable()
        {
            gvProgress.DataSource = null;
            gvProgress.DataBind();

            lblTotalStudents.Text = "0";
            lblGoodStanding.Text = "0";
            lblWarningStudents.Text = "0";
            lblHighRiskStudents.Text = "0";
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
