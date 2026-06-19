using System;
using System.Configuration;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            if (txtEmail.Text == "" || txtNewPassword.Text == "" || txtConfirmPassword.Text == "")
            {
                lblMessage.CssClass = "text-danger mt-3 d-block text-center";
                lblMessage.Text = "Please fill in all fields.";
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                lblMessage.CssClass = "text-danger mt-3 d-block text-center";
                lblMessage.Text = "Passwords do not match.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string checkQuery = "SELECT COUNT(*) FROM AdminUser WHERE Email = @Email";

                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", txtEmail.Text);

                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (count == 0)
                    {
                        lblMessage.CssClass = "text-danger mt-3 d-block text-center";
                        lblMessage.Text = "Email not found.";
                        return;
                    }
                }

                string updateQuery = "UPDATE AdminUser SET Password = @Password WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Password", txtNewPassword.Text);
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);

                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.CssClass = "text-success mt-3 d-block text-center";
            lblMessage.Text = "Password reset successful. You can now login with your new password.";

            txtEmail.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
    }
}