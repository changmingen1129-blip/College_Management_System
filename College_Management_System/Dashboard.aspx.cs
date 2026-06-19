using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboardCounts();
                LoadRecentEnrolments();
            }
        }

        private void LoadDashboardCounts()
        {
            lblProgrammeCount.Text = GetTotalCount("Programme").ToString();
            lblCourseCount.Text = GetTotalCount("Course").ToString();
            lblStudentCount.Text = GetTotalCount("Student").ToString();
            lblLecturerCount.Text = GetTotalCount("Lecturer").ToString();
        }

        private int GetTotalCount(string tableName)
        {
            int total = 0;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "";

                if (tableName == "Programme")
                {
                    query = "SELECT COUNT(*) FROM Programme";
                }
                else if (tableName == "Course")
                {
                    query = "SELECT COUNT(*) FROM Course";
                }
                else if (tableName == "Student")
                {
                    query = "SELECT COUNT(*) FROM Student";
                }
                else if (tableName == "Lecturer")
                {
                    query = "SELECT COUNT(*) FROM Lecturer";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    total = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }

            return total;
        }

        private void LoadRecentEnrolments()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5
                        s.StudentName,
                        c.CourseName,
                        e.EnrolDate,
                        e.Status
                    FROM Enrolment e
                    INNER JOIN Student s
                        ON e.StudentID = s.StudentID
                    INNER JOIN Course c
                        ON e.CourseID = c.CourseID
                    ORDER BY e.EnrolDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvRecentEnrolments.DataSource = dt;
                        gvRecentEnrolments.DataBind();
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}