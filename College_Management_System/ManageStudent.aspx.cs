using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class ManageStudent : System.Web.UI.Page
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
                LoadProgrammes();
                LoadStudents("");
            }
        }

        private void LoadProgrammes()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT ProgrammeID, ProgrammeName
                    FROM Programme
                    ORDER BY ProgrammeName";

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

        private void LoadStudents(string keyword)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        s.StudentID,
                        s.StudentName,
                        s.Email,
                        ISNULL(s.Password, '-') AS Password,
                        ISNULL(p.ProgrammeName, '-') AS ProgrammeName,
                        ISNULL(p.ProgrammeCode, '-') AS ProgrammeCode
                    FROM Student s
                    LEFT JOIN Programme p
                        ON s.ProgrammeID = p.ProgrammeID
                    WHERE 
                        (@Keyword = '' 
                        OR s.StudentName LIKE '%' + @Keyword + '%'
                        OR s.Email LIKE '%' + @Keyword + '%')
                    ORDER BY s.StudentID DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvStudents.DataSource = dt;
                        gvStudents.DataBind();
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string studentName = txtStudentName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            int programmeID = Convert.ToInt32(ddlProgramme.SelectedValue);
            int studentID = Convert.ToInt32(hfStudentID.Value);

            if (studentName == "" || email == "" || password == "" || programmeID == 0)
            {
                ShowMessage("Please fill in student name, email, password, and programme.", "danger");
                return;
            }

            if (studentID == 0)
            {
                if (IsEmailExists(email))
                {
                    ShowMessage("This student email already exists.", "danger");
                    return;
                }

                InsertStudent(studentName, email, password, programmeID);
                ShowMessage("Student added successfully.", "success");
            }
            else
            {
                if (IsEmailExistsForOtherStudent(email, studentID))
                {
                    ShowMessage("This email is already used by another student.", "danger");
                    return;
                }

                UpdateStudent(studentID, studentName, email, password, programmeID);
                ShowMessage("Student updated successfully.", "success");
            }

            ClearForm();
            LoadStudents(txtSearch.Text.Trim());
        }

        private void InsertStudent(string studentName, string email, string password, int programmeID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Student (StudentName, Email, Password, ProgrammeID)
                    VALUES (@StudentName, @Email, @Password, @ProgrammeID)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentName", studentName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@ProgrammeID", programmeID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateStudent(int studentID, string studentName, string email, string password, int programmeID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Student
                    SET StudentName = @StudentName,
                        Email = @Email,
                        Password = @Password,
                        ProgrammeID = @ProgrammeID
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentName", studentName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@ProgrammeID", programmeID);
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool IsEmailExists(string email)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Student
                    WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private bool IsEmailExistsForOtherStudent(string email, int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Student
                    WHERE Email = @Email
                    AND StudentID <> @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int studentID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditStudent")
            {
                LoadStudentForEdit(studentID);
            }
            else if (e.CommandName == "ResetPassword")
            {
                ResetPassword(studentID);
                ShowMessage("Student password reset to 123456.", "success");
                LoadStudents(txtSearch.Text.Trim());
            }
            else if (e.CommandName == "DeleteStudent")
            {
                if (IsStudentEnrolled(studentID))
                {
                    ShowMessage("Cannot delete this student because the student has enrolment records.", "danger");
                    return;
                }

                DeleteStudent(studentID);
                ShowMessage("Student deleted successfully.", "success");
                LoadStudents(txtSearch.Text.Trim());
            }
        }

        private void LoadStudentForEdit(int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT StudentID, StudentName, Email, Password, ProgrammeID
                    FROM Student
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfStudentID.Value = reader["StudentID"].ToString();
                            txtStudentName.Text = reader["StudentName"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            txtPassword.Text = reader["Password"].ToString();

                            if (reader["ProgrammeID"] != DBNull.Value)
                            {
                                ddlProgramme.SelectedValue = reader["ProgrammeID"].ToString();
                            }
                            else
                            {
                                ddlProgramme.SelectedValue = "0";
                            }

                            btnSave.Text = "Update Student";
                        }
                    }
                }
            }
        }

        private void ResetPassword(int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Student
                    SET Password = '123456'
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool IsStudentEnrolled(int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Enrolment
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private void DeleteStudent(int studentID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    DELETE FROM Student
                    WHERE StudentID = @StudentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    con.Open();
                    cmd.ExecuteNonQuery();
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

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfStudentID.Value = "0";
            txtStudentName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            ddlProgramme.SelectedIndex = 0;
            btnSave.Text = "Save Student";
        }

        private void ShowMessage(string message, string type)
        {
            if (type == "success")
            {
                lblMsg.CssClass = "text-success fw-bold";
            }
            else
            {
                lblMsg.CssClass = "text-danger fw-bold";
            }

            lblMsg.Text = message;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}