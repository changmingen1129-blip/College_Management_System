using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class LecturerCourses : System.Web.UI.Page
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
                LoadCourses();
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

        private void LoadCourses()
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CourseID,
                        c.CourseCode,
                        c.CourseName,
                        c.CreditHours,
                        ISNULL(p.ProgrammeCode, '-') AS ProgrammeCode,
                        ISNULL(p.ProgrammeName, '-') AS ProgrammeName,
                        COUNT(DISTINCT e.StudentID) AS TotalStudents
                    FROM LecturerCourse lc
                    INNER JOIN Course c
                        ON lc.CourseID = c.CourseID
                    LEFT JOIN Programme p
                        ON c.ProgrammeID = p.ProgrammeID
                    LEFT JOIN Enrolment e
                        ON c.CourseID = e.CourseID
                    WHERE lc.LecturerID = @LecturerID
                    GROUP BY 
                        c.CourseID,
                        c.CourseCode,
                        c.CourseName,
                        c.CreditHours,
                        p.ProgrammeCode,
                        p.ProgrammeName
                    ORDER BY c.CourseCode";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvCourses.DataSource = dt;
                        gvCourses.DataBind();

                        lblTotalCourses.Text = dt.Rows.Count.ToString();
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