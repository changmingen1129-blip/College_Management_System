using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class LecturerDashboard : System.Web.UI.Page
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
                LoadLecturerInfo();
                LoadDashboardCounts();
                LoadTodayClasses();
                LoadUpcomingSchedule();
            }
        }

        private void LoadLecturerInfo()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT LecturerName, Email
                    FROM Lecturer
                    WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string lecturerName = reader["LecturerName"].ToString();

                            lblLecturerName.Text = lecturerName;

                            Session["LecturerName"] = lecturerName;
                            Session["LecturerEmail"] = reader["Email"].ToString();

                            if (!string.IsNullOrWhiteSpace(lecturerName))
                            {
                                lblInitial.Text = lecturerName.Substring(0, 1).ToUpper();
                            }
                            else
                            {
                                lblInitial.Text = "L";
                            }
                        }
                        else
                        {
                            Session.Clear();
                            Session.Abandon();
                            Response.Redirect("LecturerLogin.aspx");
                        }
                    }
                }
            }
        }

        private void LoadDashboardCounts()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string assignedCoursesQuery = @"
                    SELECT COUNT(DISTINCT CourseID)
                    FROM LecturerCourse
                    WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(assignedCoursesQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    lblAssignedCourses.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }

                string totalStudentsQuery = @"
                    SELECT COUNT(DISTINCT e.StudentID)
                    FROM Enrolment e
                    INNER JOIN LecturerCourse lc
                        ON e.CourseID = lc.CourseID
                    WHERE lc.LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(totalStudentsQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    lblTotalStudents.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }

                string todayClassesQuery = @"
                    SELECT COUNT(*)
                    FROM Schedule
                    WHERE LecturerID = @LecturerID
                    AND DayOfWeek = @DayOfWeek";

                using (SqlCommand cmd = new SqlCommand(todayClassesQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@DayOfWeek", DateTime.Now.DayOfWeek.ToString());
                    lblTodayClasses.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }

                string weeklyScheduleQuery = @"
                    SELECT COUNT(*)
                    FROM Schedule
                    WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(weeklyScheduleQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    lblWeeklySchedule.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }
            }
        }

        private void LoadTodayClasses()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);
            string today = DateTime.Now.DayOfWeek.ToString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CourseCode,
                        c.CourseName,
                        CONVERT(VARCHAR(5), s.StartTime, 108) AS StartTime,
                        CONVERT(VARCHAR(5), s.EndTime, 108) AS EndTime,
                        s.Room
                    FROM Schedule s
                    INNER JOIN Course c
                        ON s.CourseID = c.CourseID
                    WHERE s.LecturerID = @LecturerID
                    AND s.DayOfWeek = @DayOfWeek
                    ORDER BY s.StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@DayOfWeek", today);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvTodayClasses.DataSource = dt;
                        gvTodayClasses.DataBind();
                    }
                }
            }
        }

        private void LoadUpcomingSchedule()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CourseCode,
                        c.CourseName,
                        s.DayOfWeek,
                        CONVERT(VARCHAR(5), s.StartTime, 108) AS StartTime,
                        CONVERT(VARCHAR(5), s.EndTime, 108) AS EndTime,
                        s.Room
                    FROM Schedule s
                    INNER JOIN Course c
                        ON s.CourseID = c.CourseID
                    WHERE s.LecturerID = @LecturerID
                    ORDER BY 
                        CASE s.DayOfWeek
                            WHEN 'Monday' THEN 1
                            WHEN 'Tuesday' THEN 2
                            WHEN 'Wednesday' THEN 3
                            WHEN 'Thursday' THEN 4
                            WHEN 'Friday' THEN 5
                            WHEN 'Saturday' THEN 6
                            WHEN 'Sunday' THEN 7
                            ELSE 8
                        END,
                        s.StartTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvUpcomingSchedule.DataSource = dt;
                        gvUpcomingSchedule.DataBind();
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