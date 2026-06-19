using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentCourses : System.Web.UI.Page
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
                LoadCourseSummary();
                LoadCourses();
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

        private void LoadCourseSummary()
        {
            int studentID = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        COUNT(*) AS TotalCourses,
                        ISNULL(SUM(c.CreditHours), 0) AS TotalCredits,
                        SUM(CASE WHEN ISNULL(e.Status, '') IN ('Enrolled', 'Approved', 'Active') THEN 1 ELSE 0 END) AS ActiveCourses
                    FROM Enrolment e
                    INNER JOIN Course c
                        ON e.CourseID = c.CourseID
                    WHERE e.StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalCourses.Text = reader["TotalCourses"].ToString();
                            lblTotalCredits.Text = reader["TotalCredits"].ToString();
                            lblActiveCourses.Text = reader["ActiveCourses"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadCourses()
        {
            int studentID = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        c.CourseCode,
                        c.CourseName,
                        c.CreditHours,
                        p.ProgrammeCode,
                        p.ProgrammeName,
                        ISNULL(l.LecturerName, 'Not assigned') AS LecturerName,
                        e.EnrolDate,
                        ISNULL(e.Status, 'Enrolled') AS Status
                    FROM Enrolment e
                    INNER JOIN Course c
                        ON e.CourseID = c.CourseID
                    INNER JOIN Programme p
                        ON c.ProgrammeID = p.ProgrammeID
                    OUTER APPLY (
                        SELECT TOP 1 
                            lec.LecturerName
                        FROM LecturerCourse lc
                        INNER JOIN Lecturer lec
                            ON lc.LecturerID = lec.LecturerID
                        WHERE lc.CourseID = c.CourseID
                        ORDER BY lec.LecturerName
                    ) l
                    WHERE e.StudentID = @StudentID
                    ORDER BY c.CourseCode";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvCourses.DataSource = dt;
                        gvCourses.DataBind();
                    }
                }
            }
        }
    }
}