using System;
using System.Configuration;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class Login : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (txtEmail.Text == "" || txtPassword.Text == "")
            {
                lblMessage.Text = "Please enter email and password.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM AdminUser WHERE Email=@Email AND Password=@Password";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    con.Close();

                    if (count == 1)
                    {
                        Session["AdminEmail"] = txtEmail.Text;
                        Response.Redirect("Dashboard.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid email or password.";
                    }
                }
            }
        }
    }
}