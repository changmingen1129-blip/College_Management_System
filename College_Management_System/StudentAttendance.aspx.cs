using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentAttendance : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                Response.Redirect("StudentLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentInfo();
                LoadAttendanceSummary();
                LoadAttendanceRecords();
            }
        }

        private void LoadStudentInfo()
        {
            string studentName = Session["StudentName"] != null ? Session["StudentName"].ToString() : "Student";

            if (!string.IsNullOrWhiteSpace(studentName))
            {
                lblInitial.Text = studentName.Substring(0, 1).ToUpper();
            }
        }

        private void LoadAttendanceSummary()
        {
            int studentID = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        COUNT(*) AS TotalRecords,
                        SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) AS PresentCount,
                        SUM(CASE WHEN Status = 'Absent' THEN 1 ELSE 0 END) AS AbsentCount
                    FROM Attendance
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int total = reader["TotalRecords"] == DBNull.Value ? 0 : Convert.ToInt32(reader["TotalRecords"]);
                            int present = reader["PresentCount"] == DBNull.Value ? 0 : Convert.ToInt32(reader["PresentCount"]);
                            int absent = reader["AbsentCount"] == DBNull.Value ? 0 : Convert.ToInt32(reader["AbsentCount"]);

                            lblTotal.Text = total.ToString();
                            lblPresent.Text = present.ToString();
                            lblAbsent.Text = absent.ToString();

                            double percentage = 0;

                            if (total > 0)
                            {
                                percentage = ((double)present / total) * 100;
                            }

                            lblPercentage.Text = percentage.ToString("0.0") + "%";
                        }
                    }
                }
            }
        }

        private void LoadAttendanceRecords()
        {
            int studentID = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        a.AttendanceDate,
                        c.CourseCode,
                        c.CourseName,
                        l.LecturerName,
                        a.Status,
                        ISNULL(a.Remarks, '-') AS Remarks
                    FROM Attendance a
                    INNER JOIN Course c
                        ON a.CourseID = c.CourseID
                    INNER JOIN Lecturer l
                        ON a.LecturerID = l.LecturerID
                    WHERE a.StudentID = @StudentID
                    ORDER BY a.AttendanceDate DESC, c.CourseCode";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvAttendance.DataSource = dt;
                        gvAttendance.DataBind();
                    }
                }
            }
        }

        public string GetStatusClass(string status)
        {
            if (status == "Present")
            {
                return "status-present";
            }
            else if (status == "Absent")
            {
                return "status-absent";
            }
            else if (status == "Late")
            {
                return "status-late";
            }
            else if (status == "Excused")
            {
                return "status-excused";
            }

            return "status-present";
        }
    }
}