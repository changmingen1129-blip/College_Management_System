using System;
using System.Configuration;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentLogin : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // No code needed here
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (txtEmail.Text.Trim() == "" || txtPassword.Text.Trim() == "")
            {
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                lblMsg.Text = "Please enter email and password.";
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT StudentID, StudentName, Email
                        FROM Student 
                        WHERE Email = @Email AND Password = @Password";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());

                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["StudentID"] = reader["StudentID"].ToString();
                                Session["StudentName"] = reader["StudentName"].ToString();
                                Session["StudentEmail"] = reader["Email"].ToString();

                                Response.Redirect("StudentDashboard.aspx");
                            }
                            else
                            {
                                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                                lblMsg.Text = "Invalid email or password.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                lblMsg.Text = "Database connection error: " + ex.Message;
            }
        }
    }
}