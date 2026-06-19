using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class StudentRegister : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProgramme();
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

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (txtName.Text == "" || txtEmail.Text == "" || txtPassword.Text == "" || txtConfirmPassword.Text == "" || ddlProgramme.SelectedValue == "0")
            {
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                lblMsg.Text = "Please fill in all fields.";
                return;
            }

            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                lblMsg.Text = "Passwords do not match.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string checkQuery = "SELECT COUNT(*) FROM Student WHERE Email = @Email";

                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text);

                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (count > 0)
                    {
                        lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                        lblMsg.Text = "This email is already registered.";
                        return;
                    }
                }

                string query = @"
                    INSERT INTO Student (StudentName, Email, Password, ProgrammeID)
                    VALUES (@StudentName, @Email, @Password, @ProgrammeID)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentName", txtName.Text);
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
                    cmd.Parameters.AddWithValue("@ProgrammeID", ddlProgramme.SelectedValue);

                    cmd.ExecuteNonQuery();
                }
            }

            lblMsg.CssClass = "text-success mt-3 d-block text-center";
            lblMsg.Text = "Registration successful. You can now login.";

            txtName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            ddlProgramme.SelectedIndex = 0;
        }
    }
}