using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class RegisterLecturer : System.Web.UI.Page
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
            }
        }

        private void LoadLecturers()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        LecturerID, 
                        LecturerName, 
                        Email, 
                        Phone,
                        Password
                    FROM Lecturer
                    ORDER BY LecturerName";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvLecturer.DataSource = dt;
                    gvLecturer.DataBind();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string lecturerName = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();

            if (lecturerName == "" || email == "")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please fill in lecturer name and email.";
                return;
            }

            if (IsEmailExists(email))
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "This lecturer email already exists.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO Lecturer (LecturerName, Email, Phone, Password)
                    VALUES (@LecturerName, @Email, @Phone, @Password)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerName", lecturerName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Password", "123456");

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Lecturer registered successfully. Default password is 123456.";

            ClearForm();
            LoadLecturers();
        }

        private bool IsEmailExists(string email)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*) 
                    FROM Lecturer
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

        private bool IsEmailExistsForOtherLecturer(string email, int lecturerID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*) 
                    FROM Lecturer
                    WHERE Email = @Email
                    AND LecturerID <> @LecturerID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        protected void gvLecturer_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvLecturer.EditIndex = e.NewEditIndex;
            LoadLecturers();
        }

        protected void gvLecturer_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvLecturer.EditIndex = -1;
            LoadLecturers();
        }

        protected void gvLecturer_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int lecturerID = Convert.ToInt32(gvLecturer.DataKeys[e.RowIndex].Value);

            GridViewRow row = gvLecturer.Rows[e.RowIndex];

            string lecturerName = ((TextBox)row.Cells[1].Controls[0]).Text.Trim();
            string email = ((TextBox)row.Cells[2].Controls[0]).Text.Trim();
            string phone = ((TextBox)row.Cells[3].Controls[0]).Text.Trim();
            string password = ((TextBox)row.Cells[4].Controls[0]).Text.Trim();

            if (lecturerName == "" || email == "" || password == "")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please fill in lecturer name, email, and password.";
                return;
            }

            if (IsEmailExistsForOtherLecturer(email, lecturerID))
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "This email is already used by another lecturer.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE Lecturer
                    SET LecturerName = @LecturerName,
                        Email = @Email,
                        Phone = @Phone,
                        Password = @Password
                    WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerName", lecturerName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvLecturer.EditIndex = -1;
            LoadLecturers();

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Lecturer updated successfully.";
        }

        protected void gvLecturer_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int lecturerID = Convert.ToInt32(gvLecturer.DataKeys[e.RowIndex].Value);

            if (IsLecturerUsedInSchedule(lecturerID))
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Cannot delete this lecturer because the lecturer is used in a schedule.";
                return;
            }

            if (IsLecturerAssignedToCourse(lecturerID))
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Cannot delete this lecturer because the lecturer is assigned to a course.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Lecturer WHERE LecturerID = @LecturerID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            LoadLecturers();

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Lecturer deleted successfully.";
        }

        private bool IsLecturerUsedInSchedule(int lecturerID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    IF OBJECT_ID('Schedule', 'U') IS NOT NULL
                    BEGIN
                        SELECT COUNT(*) 
                        FROM Schedule
                        WHERE LecturerID = @LecturerID
                    END
                    ELSE
                    BEGIN
                        SELECT 0
                    END";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private bool IsLecturerAssignedToCourse(int lecturerID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    IF OBJECT_ID('LecturerCourse', 'U') IS NOT NULL
                    BEGIN
                        SELECT COUNT(*) 
                        FROM LecturerCourse
                        WHERE LecturerID = @LecturerID
                    END
                    ELSE
                    BEGIN
                        SELECT 0
                    END";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    con.Open();

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}