using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class LecturerProfile : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LecturerID"] == null)
            {
                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            int lecturerID;

            if (!int.TryParse(
                Session["LecturerID"].ToString(),
                out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("LecturerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturerProfile(lecturerID);
                LoadAssignedCourses(lecturerID);
            }
        }

        private void LoadLecturerProfile(int lecturerID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    LecturerID,
                    LecturerName,
                    Email,
                    Phone
                FROM Lecturer
                WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblLecturerID.Text =
                                reader["LecturerID"].ToString();

                            lblLecturerName.Text =
                                reader["LecturerName"].ToString();

                            string email =
                                reader["Email"] == DBNull.Value
                                    ? ""
                                    : reader["Email"].ToString();

                            string phone =
                                reader["Phone"] == DBNull.Value
                                    ? ""
                                    : reader["Phone"].ToString();

                            lblCurrentEmail.Text =
                                string.IsNullOrWhiteSpace(email)
                                    ? "-"
                                    : email;

                            lblCurrentPhone.Text =
                                string.IsNullOrWhiteSpace(phone)
                                    ? "-"
                                    : phone;

                            txtEmail.Text = email;
                            txtPhone.Text = phone;
                        }
                        else
                        {
                            lblLecturerID.Text = "-";
                            lblLecturerName.Text = "-";
                            lblCurrentEmail.Text = "-";
                            lblCurrentPhone.Text = "-";

                            txtEmail.Text = "";
                            txtPhone.Text = "";
                        }
                    }
                }
            }
        }

        private void LoadAssignedCourses(int lecturerID)
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseCode,
                    c.CourseName,
                    c.CreditHours,
                    ISNULL(p.ProgrammeName, '-') AS ProgrammeName
                FROM LecturerCourse lc

                INNER JOIN Course c
                    ON lc.CourseID = c.CourseID

                LEFT JOIN Programme p
                    ON c.ProgrammeID = p.ProgrammeID

                WHERE lc.LecturerID = @LecturerID

                ORDER BY
                    c.CourseCode,
                    c.CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            gvAssignedCourses.DataSource = table;
            gvAssignedCourses.DataBind();
        }

        protected void btnUpdateProfile_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            if (!Page.IsValid)
            {
                ShowProfileMessage(
                    "Please enter a valid email address.",
                    false
                );

                return;
            }

            int lecturerID;

            if (!TryGetLecturerID(out lecturerID))
            {
                return;
            }

            string email =
                txtEmail.Text.Trim();

            string phone =
                txtPhone.Text.Trim();

            if (string.IsNullOrWhiteSpace(email))
            {
                ShowProfileMessage(
                    "Email address is required.",
                    false
                );

                return;
            }

            if (EmailBelongsToAnotherLecturer(
                email,
                lecturerID))
            {
                ShowProfileMessage(
                    "This email address is already used by another lecturer.",
                    false
                );

                return;
            }

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                UPDATE Lecturer
                SET
                    Email = @Email,
                    Phone = @Phone
                WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        150
                    ).Value = email;

                    if (string.IsNullOrWhiteSpace(phone))
                    {
                        cmd.Parameters.Add(
                            "@Phone",
                            SqlDbType.VarChar,
                            30
                        ).Value = DBNull.Value;
                    }
                    else
                    {
                        cmd.Parameters.Add(
                            "@Phone",
                            SqlDbType.VarChar,
                            30
                        ).Value = phone;
                    }

                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        lblCurrentEmail.Text = email;

                        lblCurrentPhone.Text =
                            string.IsNullOrWhiteSpace(phone)
                                ? "-"
                                : phone;

                        ShowProfileMessage(
                            "Contact information updated successfully.",
                            true
                        );
                    }
                    else
                    {
                        ShowProfileMessage(
                            "Unable to update contact information.",
                            false
                        );
                    }
                }
            }
        }

        protected void btnChangePassword_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            int lecturerID;

            if (!TryGetLecturerID(out lecturerID))
            {
                return;
            }

            string currentPassword =
                txtCurrentPassword.Text.Trim();

            string newPassword =
                txtNewPassword.Text.Trim();

            string confirmPassword =
                txtConfirmPassword.Text.Trim();

            if (
                string.IsNullOrWhiteSpace(currentPassword)
                || string.IsNullOrWhiteSpace(newPassword)
                || string.IsNullOrWhiteSpace(confirmPassword)
            )
            {
                ShowPasswordMessage(
                    "Please complete all password fields.",
                    false
                );

                return;
            }

            if (newPassword.Length < 6)
            {
                ShowPasswordMessage(
                    "The new password must contain at least 6 characters.",
                    false
                );

                return;
            }

            if (newPassword != confirmPassword)
            {
                ShowPasswordMessage(
                    "The new password and confirmation password do not match.",
                    false
                );

                return;
            }

            if (currentPassword == newPassword)
            {
                ShowPasswordMessage(
                    "The new password must be different from the current password.",
                    false
                );

                return;
            }

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                string checkQuery = @"
                SELECT COUNT(*)
                FROM Lecturer
                WHERE LecturerID = @LecturerID
                  AND Password = @CurrentPassword";

                using (SqlCommand checkCmd =
                    new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    checkCmd.Parameters.Add(
                        "@CurrentPassword",
                        SqlDbType.VarChar,
                        100
                    ).Value = currentPassword;

                    int matchedLecturers =
                        Convert.ToInt32(
                            checkCmd.ExecuteScalar()
                        );

                    if (matchedLecturers == 0)
                    {
                        ShowPasswordMessage(
                            "The current password is incorrect.",
                            false
                        );

                        return;
                    }
                }

                string updateQuery = @"
                UPDATE Lecturer
                SET Password = @NewPassword
                WHERE LecturerID = @LecturerID";

                using (SqlCommand updateCmd =
                    new SqlCommand(updateQuery, con))
                {
                    updateCmd.Parameters.Add(
                        "@NewPassword",
                        SqlDbType.VarChar,
                        100
                    ).Value = newPassword;

                    updateCmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    int affectedRows =
                        updateCmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        ClearPasswordFields();

                        ShowPasswordMessage(
                            "Password changed successfully.",
                            true
                        );
                    }
                    else
                    {
                        ShowPasswordMessage(
                            "Unable to change the password.",
                            false
                        );
                    }
                }
            }
        }

        private bool EmailBelongsToAnotherLecturer(
            string email,
            int lecturerID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT COUNT(*)
                FROM Lecturer
                WHERE Email = @Email
                  AND LecturerID <> @LecturerID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        150
                    ).Value = email;

                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    con.Open();

                    int count =
                        Convert.ToInt32(
                            cmd.ExecuteScalar()
                        );

                    return count > 0;
                }
            }
        }

        private bool TryGetLecturerID(
            out int lecturerID)
        {
            lecturerID = 0;

            if (Session["LecturerID"] == null)
            {
                Response.Redirect("LecturerLogin.aspx");
                return false;
            }

            if (!int.TryParse(
                Session["LecturerID"].ToString(),
                out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("LecturerLogin.aspx");
                return false;
            }

            return true;
        }

        private void ShowProfileMessage(
            string message,
            bool success)
        {
            lblProfileMessage.Visible = true;
            lblProfileMessage.Text = message;

            lblProfileMessage.CssClass =
                success
                    ? "message-label alert alert-success"
                    : "message-label alert alert-danger";
        }

        private void ShowPasswordMessage(
            string message,
            bool success)
        {
            lblPasswordMessage.Visible = true;
            lblPasswordMessage.Text = message;

            lblPasswordMessage.CssClass =
                success
                    ? "message-label alert alert-success"
                    : "message-label alert alert-danger";
        }

        private void HideMessages()
        {
            lblProfileMessage.Visible = false;
            lblProfileMessage.Text = "";

            lblPasswordMessage.Visible = false;
            lblPasswordMessage.Text = "";
        }

        private void ClearPasswordFields()
        {
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
    }


}
