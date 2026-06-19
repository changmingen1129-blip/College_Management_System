using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentProfile : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                Response.Redirect("StudentLogin.aspx");
                return;
            }

            int studentID;

            if (!int.TryParse(Session["StudentID"].ToString(), out studentID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("StudentLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentProfile(studentID);
            }
        }

        private void LoadStudentProfile(int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    s.StudentID,
                    s.StudentName,
                    s.Email,
                    p.ProgrammeCode,
                    p.ProgrammeName
                FROM Student s
                LEFT JOIN Programme p
                    ON s.ProgrammeID = p.ProgrammeID
                WHERE s.StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblStudentID.Text =
                                reader["StudentID"].ToString();

                            lblStudentName.Text =
                                reader["StudentName"].ToString();

                            lblCurrentEmail.Text =
                                reader["Email"].ToString();

                            txtEmail.Text =
                                reader["Email"].ToString();

                            string programmeCode =
                                reader["ProgrammeCode"] == DBNull.Value
                                    ? ""
                                    : reader["ProgrammeCode"].ToString();

                            string programmeName =
                                reader["ProgrammeName"] == DBNull.Value
                                    ? ""
                                    : reader["ProgrammeName"].ToString();

                            if (
                                string.IsNullOrWhiteSpace(programmeCode)
                                && string.IsNullOrWhiteSpace(programmeName)
                            )
                            {
                                lblProgramme.Text =
                                    "No Programme Assigned";
                            }
                            else
                            {
                                lblProgramme.Text =
                                    programmeCode
                                    + " - "
                                    + programmeName;
                            }
                        }
                        else
                        {
                            lblStudentID.Text = "-";
                            lblStudentName.Text = "-";
                            lblCurrentEmail.Text = "-";
                            lblProgramme.Text = "-";
                            txtEmail.Text = "";
                        }
                    }
                }
            }
        }

        protected void btnUpdateEmail_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            if (!Page.IsValid)
            {
                ShowEmailMessage(
                    "Please enter a valid email address.",
                    false
                );

                return;
            }

            int studentID;

            if (!TryGetStudentID(out studentID))
            {
                return;
            }

            string newEmail =
                txtEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(newEmail))
            {
                ShowEmailMessage(
                    "Email address is required.",
                    false
                );

                return;
            }

            if (EmailBelongsToAnotherStudent(
                newEmail,
                studentID))
            {
                ShowEmailMessage(
                    "This email address is already used by another student.",
                    false
                );

                return;
            }

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                UPDATE Student
                SET Email = @Email
                WHERE StudentID = @StudentID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        150
                    ).Value = newEmail;

                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        lblCurrentEmail.Text =
                            newEmail;

                        ShowEmailMessage(
                            "Email address updated successfully.",
                            true
                        );
                    }
                    else
                    {
                        ShowEmailMessage(
                            "Unable to update the email address.",
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

            int studentID;

            if (!TryGetStudentID(out studentID))
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
                FROM Student
                WHERE StudentID = @StudentID
                  AND Password = @CurrentPassword";

                using (SqlCommand checkCmd =
                    new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    checkCmd.Parameters.Add(
                        "@CurrentPassword",
                        SqlDbType.VarChar,
                        100
                    ).Value = currentPassword;

                    int matchedStudents =
                        Convert.ToInt32(
                            checkCmd.ExecuteScalar()
                        );

                    if (matchedStudents == 0)
                    {
                        ShowPasswordMessage(
                            "The current password is incorrect.",
                            false
                        );

                        return;
                    }
                }

                string updateQuery = @"
                UPDATE Student
                SET Password = @NewPassword
                WHERE StudentID = @StudentID";

                using (SqlCommand updateCmd =
                    new SqlCommand(updateQuery, con))
                {
                    updateCmd.Parameters.Add(
                        "@NewPassword",
                        SqlDbType.VarChar,
                        100
                    ).Value = newPassword;

                    updateCmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

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

        private bool EmailBelongsToAnotherStudent(
            string email,
            int studentID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT COUNT(*)
                FROM Student
                WHERE Email = @Email
                  AND StudentID <> @StudentID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        150
                    ).Value = email;

                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    con.Open();

                    int count =
                        Convert.ToInt32(
                            cmd.ExecuteScalar()
                        );

                    return count > 0;
                }
            }
        }

        private bool TryGetStudentID(
            out int studentID)
        {
            studentID = 0;

            if (Session["StudentID"] == null)
            {
                Response.Redirect("StudentLogin.aspx");
                return false;
            }

            if (!int.TryParse(
                Session["StudentID"].ToString(),
                out studentID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("StudentLogin.aspx");
                return false;
            }

            return true;
        }

        private void ShowEmailMessage(
            string message,
            bool success)
        {
            lblEmailMessage.Visible = true;
            lblEmailMessage.Text = message;

            lblEmailMessage.CssClass =
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
            lblEmailMessage.Visible = false;
            lblEmailMessage.Text = "";

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
