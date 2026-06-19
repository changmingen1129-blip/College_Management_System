using System;
using System.Configuration;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class LecturerLogin : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // No code needed here
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (email == "" || password == "")
            {
                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                lblMsg.Text = "Please enter email and password.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT LecturerID, LecturerName, Email
                    FROM Lecturer
                    WHERE Email = @Email
                    AND Password = @Password";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    try
                    {
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["LecturerID"] = reader["LecturerID"].ToString();
                                Session["LecturerName"] = reader["LecturerName"].ToString();
                                Session["LecturerEmail"] = reader["Email"].ToString();

                                Response.Redirect("LecturerDashboard.aspx");
                            }
                            else
                            {
                                lblMsg.CssClass = "text-danger mt-3 d-block text-center";
                                lblMsg.Text = "Invalid lecturer email or password.";
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
    }
}