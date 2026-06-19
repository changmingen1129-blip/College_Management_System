using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class LecturerStudents : System.Web.UI.Page
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
                LoadStudents("");
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

        private void LoadStudents(string keyword)
        {
            int lecturerID = Convert.ToInt32(Session["LecturerID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CourseCode,
                        c.CourseName,
                        s.StudentName,
                        s.Email,
                        ISNULL(p.ProgrammeCode, '-') AS ProgrammeCode,
                        ISNULL(p.ProgrammeName, '-') AS ProgrammeName,
                        e.EnrolDate,
                        ISNULL(e.Status, 'Enrolled') AS Status
                    FROM LecturerCourse lc
                    INNER JOIN Course c
                        ON lc.CourseID = c.CourseID
                    INNER JOIN Enrolment e
                        ON c.CourseID = e.CourseID
                    INNER JOIN Student s
                        ON e.StudentID = s.StudentID
                    LEFT JOIN Programme p
                        ON s.ProgrammeID = p.ProgrammeID
                    WHERE lc.LecturerID = @LecturerID
                    AND (
                        @Keyword = ''
                        OR s.StudentName LIKE '%' + @Keyword + '%'
                        OR s.Email LIKE '%' + @Keyword + '%'
                        OR c.CourseCode LIKE '%' + @Keyword + '%'
                        OR c.CourseName LIKE '%' + @Keyword + '%'
                    )
                    ORDER BY c.CourseCode, s.StudentName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);
                    cmd.Parameters.AddWithValue("@Keyword", keyword);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvStudents.DataSource = dt;
                        gvStudents.DataBind();

                        lblTotalStudents.Text = dt.Rows.Count.ToString();
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadStudents(txtSearch.Text.Trim());
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadStudents("");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("LecturerLogin.aspx");
        }
    }
}