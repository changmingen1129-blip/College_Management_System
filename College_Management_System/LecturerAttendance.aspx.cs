using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class LecturerAttendance : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LecturerID"] == null)
            {
                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                txtAttendanceDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                LoadCourses();
                LoadAttendanceReport();
                ResetSummary();
            }
        }

        private void LoadCourses()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT DISTINCT 
                        c.CourseID,
                        c.CourseCode + ' - ' + c.CourseName AS CourseDisplay
                    FROM LecturerCourse lc
                    INNER JOIN Course c
                        ON lc.CourseID = c.CourseID
                    WHERE lc.LecturerID = @LecturerID
                    ORDER BY CourseDisplay";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlCourse.DataSource = dt;
                        ddlCourse.DataTextField = "CourseDisplay";
                        ddlCourse.DataValueField = "CourseID";
                        ddlCourse.DataBind();

                        ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));
                    }
                }
            }
        }

        protected void btnLoadStudents_Click(object sender, EventArgs e)
        {
            LoadStudentsForAttendance();
            LoadExistingAttendanceIntoGrid();
            LoadSummary();
        }

        private void LoadStudentsForAttendance()
        {
            lblMsg.Text = "";
            ResetSummary();

            if (ddlCourse.SelectedValue == "0")
            {
                lblMsg.Text = "Please select a course.";
                lblMsg.CssClass = "text-danger message-label";
                gvStudents.DataSource = null;
                gvStudents.DataBind();
                return;
            }

            int courseID = Convert.ToInt32(ddlCourse.SelectedValue);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT DISTINCT 
                        s.StudentID,
                        s.StudentName,
                        s.Email
                    FROM Enrolment e
                    INNER JOIN Student s
                        ON e.StudentID = s.StudentID
                    WHERE e.CourseID = @CourseID
                    ORDER BY s.StudentName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvStudents.DataSource = dt;
                        gvStudents.DataBind();

                        lblTotal.Text = dt.Rows.Count.ToString();

                        if (dt.Rows.Count == 0)
                        {
                            lblMsg.Text = "No students found for this course.";
                            lblMsg.CssClass = "text-warning message-label";
                        }
                    }
                }
            }
        }

        private void LoadExistingAttendanceIntoGrid()
        {
            if (ddlCourse.SelectedValue == "0" || string.IsNullOrWhiteSpace(txtAttendanceDate.Text))
            {
                return;
            }

            int courseID = Convert.ToInt32(ddlCourse.SelectedValue);
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);
            DateTime attendanceDate = Convert.ToDateTime(txtAttendanceDate.Text);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT StudentID, Status, Remarks
                    FROM Attendance
                    WHERE CourseID = @CourseID
                    AND LecturerID = @LecturerID
                    AND AttendanceDate = @AttendanceDate";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int studentID = Convert.ToInt32(reader["StudentID"]);
                            string status = reader["Status"].ToString();
                            string remarks = reader["Remarks"].ToString();

                            foreach (GridViewRow row in gvStudents.Rows)
                            {
                                int rowStudentID = Convert.ToInt32(gvStudents.DataKeys[row.RowIndex].Value);

                                if (rowStudentID == studentID)
                                {
                                    DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
                                    TextBox txtRemarks = (TextBox)row.FindControl("txtRemarks");

                                    if (ddlStatus != null && ddlStatus.Items.FindByText(status) != null)
                                    {
                                        ddlStatus.SelectedValue = status;
                                    }

                                    if (txtRemarks != null)
                                    {
                                        txtRemarks.Text = remarks;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        protected void btnSaveAttendance_Click(object sender, EventArgs e)
        {
            if (ddlCourse.SelectedValue == "0")
            {
                lblMsg.Text = "Please select a course first.";
                lblMsg.CssClass = "text-danger message-label";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtAttendanceDate.Text))
            {
                lblMsg.Text = "Please select an attendance date.";
                lblMsg.CssClass = "text-danger message-label";
                return;
            }

            if (gvStudents.Rows.Count == 0)
            {
                lblMsg.Text = "Please load students before saving attendance.";
                lblMsg.CssClass = "text-danger message-label";
                return;
            }

            int courseID = Convert.ToInt32(ddlCourse.SelectedValue);
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);
            DateTime attendanceDate = Convert.ToDateTime(txtAttendanceDate.Text);
            int? scheduleID = GetScheduleID(courseID, lecturerID, attendanceDate);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                foreach (GridViewRow row in gvStudents.Rows)
                {
                    int studentID = Convert.ToInt32(gvStudents.DataKeys[row.RowIndex].Value);

                    DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatus");
                    TextBox txtRemarks = (TextBox)row.FindControl("txtRemarks");

                    string status = ddlStatus.SelectedValue;
                    string remarks = txtRemarks.Text.Trim();

                    int existingAttendanceID = GetExistingAttendanceID(con, studentID, courseID, lecturerID, attendanceDate);

                    if (existingAttendanceID > 0)
                    {
                        string updateQuery = @"
                            UPDATE Attendance
                            SET Status = @Status,
                                Remarks = @Remarks,
                                ScheduleID = @ScheduleID
                            WHERE AttendanceID = @AttendanceID";

                        using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@Status", status);
                            cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrWhiteSpace(remarks) ? (object)DBNull.Value : remarks);
                            cmd.Parameters.AddWithValue("@ScheduleID", scheduleID.HasValue ? (object)scheduleID.Value : DBNull.Value);
                            cmd.Parameters.AddWithValue("@AttendanceID", existingAttendanceID);

                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertQuery = @"
                            INSERT INTO Attendance
                            (StudentID, CourseID, LecturerID, ScheduleID, AttendanceDate, Status, Remarks)
                            VALUES
                            (@StudentID, @CourseID, @LecturerID, @ScheduleID, @AttendanceDate, @Status, @Remarks)";

                        using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@StudentID", studentID);
                            cmd.Parameters.AddWithValue("@CourseID", courseID);
                            cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                            cmd.Parameters.AddWithValue("@ScheduleID", scheduleID.HasValue ? (object)scheduleID.Value : DBNull.Value);
                            cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);
                            cmd.Parameters.AddWithValue("@Status", status);
                            cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrWhiteSpace(remarks) ? (object)DBNull.Value : remarks);

                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            lblMsg.Text = "Attendance saved successfully.";
            lblMsg.CssClass = "text-success message-label";

            LoadAttendanceReport();
            LoadSummary();
        }

        private int GetExistingAttendanceID(SqlConnection con, int studentID, int courseID, int lecturerID, DateTime attendanceDate)
        {
            string query = @"
                SELECT AttendanceID
                FROM Attendance
                WHERE StudentID = @StudentID
                AND CourseID = @CourseID
                AND LecturerID = @LecturerID
                AND AttendanceDate = @AttendanceDate";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentID);
                cmd.Parameters.AddWithValue("@CourseID", courseID);
                cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    return Convert.ToInt32(result);
                }

                return 0;
            }
        }

        private int? GetScheduleID(int courseID, int lecturerID, DateTime attendanceDate)
        {
            string dayOfWeek = attendanceDate.DayOfWeek.ToString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 1 ScheduleID
                    FROM Schedule
                    WHERE CourseID = @CourseID
                    AND LecturerID = @LecturerID
                    AND DayOfWeek = @DayOfWeek
                    ORDER BY StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@DayOfWeek", dayOfWeek);

                    con.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        return Convert.ToInt32(result);
                    }

                    return null;
                }
            }
        }

        private void LoadSummary()
        {
            ResetSummary();

            if (ddlCourse.SelectedValue == "0" || string.IsNullOrWhiteSpace(txtAttendanceDate.Text))
            {
                return;
            }

            int courseID = Convert.ToInt32(ddlCourse.SelectedValue);
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);
            DateTime attendanceDate = Convert.ToDateTime(txtAttendanceDate.Text);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        COUNT(*) AS Total,
                        SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) AS PresentCount,
                        SUM(CASE WHEN Status = 'Absent' THEN 1 ELSE 0 END) AS AbsentCount,
                        SUM(CASE WHEN Status IN ('Late', 'Excused') THEN 1 ELSE 0 END) AS LateExcusedCount
                    FROM Attendance
                    WHERE CourseID = @CourseID
                    AND LecturerID = @LecturerID
                    AND AttendanceDate = @AttendanceDate";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@AttendanceDate", attendanceDate);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotal.Text = reader["Total"].ToString();
                            lblPresent.Text = reader["PresentCount"].ToString();
                            lblAbsent.Text = reader["AbsentCount"].ToString();
                            lblLate.Text = reader["LateExcusedCount"].ToString();
                        }
                    }
                }
            }
        }

        private void ResetSummary()
        {
            lblTotal.Text = "0";
            lblPresent.Text = "0";
            lblAbsent.Text = "0";
            lblLate.Text = "0";
        }

        private void LoadAttendanceReport()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 100
                        a.AttendanceDate,
                        c.CourseCode,
                        c.CourseName,
                        s.StudentName,
                        a.Status,
                        ISNULL(a.Remarks, '') AS Remarks
                    FROM Attendance a
                    INNER JOIN Student s
                        ON a.StudentID = s.StudentID
                    INNER JOIN Course c
                        ON a.CourseID = c.CourseID
                    WHERE a.LecturerID = @LecturerID
                    ORDER BY a.AttendanceDate DESC, c.CourseCode, s.StudentName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvReport.DataSource = dt;
                        gvReport.DataBind();
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("LecturerLogin.aspx");
        }
    }
}