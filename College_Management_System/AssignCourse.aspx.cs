using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class AssignCourse : System.Web.UI.Page
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
                LoadLecturers();
                LoadCourses();
                LoadAssignedCourses();
            }
        }

        private void LoadLecturers()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT LecturerID, LecturerName FROM Lecturer";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlLecturer.DataSource = cmd.ExecuteReader();
                    ddlLecturer.DataTextField = "LecturerName";
                    ddlLecturer.DataValueField = "LecturerID";
                    ddlLecturer.DataBind();

                    ddlLecturer.Items.Insert(0, new ListItem("-- Select Lecturer --", "0"));
                }
            }
        }

        private void LoadCourses()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT CourseID, CourseName FROM Course";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlCourse.DataSource = cmd.ExecuteReader();
                    ddlCourse.DataTextField = "CourseName";
                    ddlCourse.DataValueField = "CourseID";
                    ddlCourse.DataBind();

                    ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));
                }
            }
        }

        private void LoadAssignedCourses()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        lc.LecturerCourseID AS ID,
                        l.LecturerName,
                        l.Email,
                        c.CourseName,
                        c.CourseCode
                    FROM LecturerCourse lc
                    INNER JOIN Lecturer l ON lc.LecturerID = l.LecturerID
                    INNER JOIN Course c ON lc.CourseID = c.CourseID";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAssign.DataSource = dt;
                    gvAssign.DataBind();
                }
            }
        }

        protected void btnAssign_Click(object sender, EventArgs e)
        {
            if (ddlLecturer.SelectedValue == "0" || ddlCourse.SelectedValue == "0")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please select lecturer and course.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string checkQuery = @"
                    SELECT COUNT(*) 
                    FROM LecturerCourse 
                    WHERE LecturerID = @LecturerID 
                    AND CourseID = @CourseID";

                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@LecturerID", ddlLecturer.SelectedValue);
                    checkCmd.Parameters.AddWithValue("@CourseID", ddlCourse.SelectedValue);

                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (count > 0)
                    {
                        lblMsg.CssClass = "text-danger";
                        lblMsg.Text = "This course is already assigned to this lecturer.";
                        return;
                    }
                }

                string insertQuery = @"
                    INSERT INTO LecturerCourse (LecturerID, CourseID)
                    VALUES (@LecturerID, @CourseID)";

                using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", ddlLecturer.SelectedValue);
                    cmd.Parameters.AddWithValue("@CourseID", ddlCourse.SelectedValue);

                    cmd.ExecuteNonQuery();
                }
            }

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Course assigned successfully.";

            ddlLecturer.SelectedIndex = 0;
            ddlCourse.SelectedIndex = 0;

            LoadAssignedCourses();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}