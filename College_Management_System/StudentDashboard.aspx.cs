using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentDashboard : System.Web.UI.Page
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
                LoadDashboardCounts();
                LoadEnrolledCourses();
            }
        }

        private void LoadStudentInfo()
        {
            int studentId = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        s.StudentID,
                        s.StudentName,
                        s.Email,
                        ISNULL(p.ProgrammeName, '-') AS ProgrammeName,
                        ISNULL(p.ProgrammeCode, '-') AS ProgrammeCode
                    FROM Student s
                    LEFT JOIN Programme p 
                        ON s.ProgrammeID = p.ProgrammeID
                    WHERE s.StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string studentName = dr["StudentName"].ToString();
                            string email = dr["Email"].ToString();
                            string programmeName = dr["ProgrammeName"].ToString();
                            string programmeCode = dr["ProgrammeCode"].ToString();

                            lblStudentName.Text = studentName;
                            lblInfoName.Text = studentName;
                            lblEmail.Text = email;

                            lblProgramme.Text = programmeCode;
                            lblInfoProgramme.Text = programmeName;

                            Session["StudentName"] = studentName;
                            Session["StudentEmail"] = email;

                            if (!string.IsNullOrWhiteSpace(studentName))
                            {
                                lblInitial.Text = studentName.Substring(0, 1).ToUpper();
                            }
                            else
                            {
                                lblInitial.Text = "S";
                            }
                        }
                        else
                        {
                            Session.Clear();
                            Session.Abandon();
                            Response.Redirect("StudentLogin.aspx");
                        }
                    }
                }
            }
        }

        private void LoadDashboardCounts()
        {
            int studentId = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string totalCourseQuery = @"
                    SELECT COUNT(*) 
                    FROM Course";

                using (SqlCommand courseCmd = new SqlCommand(totalCourseQuery, con))
                {
                    int totalCourses = Convert.ToInt32(courseCmd.ExecuteScalar());
                    lblTotalCourses.Text = totalCourses.ToString();
                }

                string enrolmentQuery = @"
                    SELECT COUNT(*) 
                    FROM Enrolment 
                    WHERE StudentID = @StudentID";

                using (SqlCommand enrolmentCmd = new SqlCommand(enrolmentQuery, con))
                {
                    enrolmentCmd.Parameters.AddWithValue("@StudentID", studentId);

                    int totalEnrolments = Convert.ToInt32(enrolmentCmd.ExecuteScalar());
                    lblTotalEnrolments.Text = totalEnrolments.ToString();
                }
            }
        }

        private void LoadEnrolledCourses()
        {
            int studentId = Convert.ToInt32(Session["StudentID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CourseCode,
                        c.CourseName,
                        c.CreditHours,
                        ISNULL(e.Status, 'Enrolled') AS Status
                    FROM Enrolment e
                    INNER JOIN Course c 
                        ON e.CourseID = c.CourseID
                    WHERE e.StudentID = @StudentID
                    ORDER BY c.CourseCode";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

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

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("StudentLogin.aspx");
        }
    }
}