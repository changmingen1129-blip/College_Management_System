using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class Course : System.Web.UI.Page
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
                LoadProgramme();
                LoadCourses();
            }
        }

        private void LoadProgramme()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ProgrammeID, ProgrammeName FROM Programme";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    ddlProgramme.DataSource = cmd.ExecuteReader();
                    ddlProgramme.DataTextField = "ProgrammeName";
                    ddlProgramme.DataValueField = "ProgrammeID";
                    ddlProgramme.DataBind();

                    ddlProgramme.Items.Insert(0, new ListItem("-- Select Programme --", "0"));
                }
            }
        }

        private void LoadCourses()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.CourseID,
                        c.CourseName,
                        c.CourseCode,
                        c.CreditHours,
                        p.ProgrammeName
                    FROM Course c
                    INNER JOIN Programme p 
                    ON c.ProgrammeID = p.ProgrammeID";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvCourse.DataSource = dt;
                    gvCourse.DataBind();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (txtName.Text == "" || txtCode.Text == "" || txtCredit.Text == "" || ddlProgramme.SelectedValue == "0")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please fill in all fields.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Course 
                    (CourseName, CourseCode, CreditHours, ProgrammeID)
                    VALUES 
                    (@CourseName, @CourseCode, @CreditHours, @ProgrammeID)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseName", txtName.Text);
                    cmd.Parameters.AddWithValue("@CourseCode", txtCode.Text);
                    cmd.Parameters.AddWithValue("@CreditHours", txtCredit.Text);
                    cmd.Parameters.AddWithValue("@ProgrammeID", ddlProgramme.SelectedValue);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Course saved successfully.";

            txtName.Text = "";
            txtCode.Text = "";
            txtCredit.Text = "";
            ddlProgramme.SelectedIndex = 0;

            LoadCourses();
        }

        protected void gvCourse_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCourse.EditIndex = e.NewEditIndex;
            LoadCourses();
        }

        protected void gvCourse_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCourse.EditIndex = -1;
            LoadCourses();
        }

        protected void gvCourse_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int courseID = Convert.ToInt32(gvCourse.DataKeys[e.RowIndex].Value);

            GridViewRow row = gvCourse.Rows[e.RowIndex];

            string courseName = ((TextBox)row.Cells[1].Controls[0]).Text;
            string courseCode = ((TextBox)row.Cells[2].Controls[0]).Text;
            string creditHours = ((TextBox)row.Cells[3].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Course
                    SET CourseName = @CourseName,
                        CourseCode = @CourseCode,
                        CreditHours = @CreditHours
                    WHERE CourseID = @CourseID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseName", courseName);
                    cmd.Parameters.AddWithValue("@CourseCode", courseCode);
                    cmd.Parameters.AddWithValue("@CreditHours", creditHours);
                    cmd.Parameters.AddWithValue("@CourseID", courseID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvCourse.EditIndex = -1;
            LoadCourses();

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Course updated successfully.";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}