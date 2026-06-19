using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class Enrolment : System.Web.UI.Page
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
                LoadDefaultCourseDropdown();
                LoadEnrolmentList();
            }
        }

        private void LoadProgramme()
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

        private void LoadDefaultCourseDropdown()
        {
            ddlCourse.Items.Clear();
            ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));
        }

        protected void ddlProgramme_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCoursesByProgramme();
        }

        private void LoadCoursesByProgramme()
        {
            ddlCourse.Items.Clear();
            ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));

            if (ddlProgramme.SelectedValue == "0")
            {
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT CourseID, CourseName 
                    FROM Course 
                    WHERE ProgrammeID = @ProgrammeID
                    ORDER BY CourseName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProgrammeID", ddlProgramme.SelectedValue);

                    con.Open();

                    ddlCourse.DataSource = cmd.ExecuteReader();
                    ddlCourse.DataTextField = "CourseName";
                    ddlCourse.DataValueField = "CourseID";
                    ddlCourse.DataBind();

                    ddlCourse.Items.Insert(0, new ListItem("-- Select Course --", "0"));
                }
            }
        }

        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            if (txtName.Text.Trim() == "" || txtEmail.Text.Trim() == "" || ddlProgramme.SelectedValue == "0")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please fill in student name, email, and programme.";
                return;
            }

            if (ddlCourse.SelectedValue == "0")
            {
                lblMsg.CssClass = "text-danger";
                lblMsg.Text = "Please select a course.";
                return;
            }

            int studentID;
            int programmeID = Convert.ToInt32(ddlProgramme.SelectedValue);
            int courseID = Convert.ToInt32(ddlCourse.SelectedValue);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                studentID = GetOrCreateStudent(con, txtName.Text.Trim(), txtEmail.Text.Trim(), programmeID);

                if (IsAlreadyEnrolled(con, studentID, courseID))
                {
                    lblMsg.CssClass = "text-warning";
                    lblMsg.Text = "This student is already enrolled in this course.";
                    return;
                }

                InsertEnrolment(con, studentID, courseID);
            }

            lblMsg.CssClass = "text-success";
            lblMsg.Text = "Student enrolled successfully. Default student password is 123456.";

            txtName.Text = "";
            txtEmail.Text = "";
            ddlProgramme.SelectedIndex = 0;
            LoadDefaultCourseDropdown();

            LoadEnrolmentList();
        }

        private int GetOrCreateStudent(SqlConnection con, string studentName, string email, int programmeID)
        {
            string checkQuery = @"
                SELECT StudentID 
                FROM Student
                WHERE Email = @Email";

            using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
            {
                checkCmd.Parameters.AddWithValue("@Email", email);

                object result = checkCmd.ExecuteScalar();

                if (result != null)
                {
                    int existingStudentID = Convert.ToInt32(result);

                    string updateQuery = @"
                        UPDATE Student
                        SET StudentName = @StudentName,
                            ProgrammeID = @ProgrammeID
                        WHERE StudentID = @StudentID";

                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                    {
                        updateCmd.Parameters.AddWithValue("@StudentName", studentName);
                        updateCmd.Parameters.AddWithValue("@ProgrammeID", programmeID);
                        updateCmd.Parameters.AddWithValue("@StudentID", existingStudentID);

                        updateCmd.ExecuteNonQuery();
                    }

                    return existingStudentID;
                }
            }

            string insertQuery = @"
                INSERT INTO Student (StudentName, Email, Password, ProgrammeID)
                VALUES (@StudentName, @Email, @Password, @ProgrammeID);
                SELECT SCOPE_IDENTITY();";

            using (SqlCommand insertCmd = new SqlCommand(insertQuery, con))
            {
                insertCmd.Parameters.AddWithValue("@StudentName", studentName);
                insertCmd.Parameters.AddWithValue("@Email", email);
                insertCmd.Parameters.AddWithValue("@Password", "123456");
                insertCmd.Parameters.AddWithValue("@ProgrammeID", programmeID);

                return Convert.ToInt32(insertCmd.ExecuteScalar());
            }
        }

        private bool IsAlreadyEnrolled(SqlConnection con, int studentID, int courseID)
        {
            string query = @"
                SELECT COUNT(*)
                FROM Enrolment
                WHERE StudentID = @StudentID
                AND CourseID = @CourseID";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentID);
                cmd.Parameters.AddWithValue("@CourseID", courseID);

                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count > 0;
            }
        }

        private void InsertEnrolment(SqlConnection con, int studentID, int courseID)
        {
            string enrolQuery = @"
                INSERT INTO Enrolment (StudentID, CourseID, EnrolDate, Status)
                VALUES (@StudentID, @CourseID, GETDATE(), 'Enrolled')";

            using (SqlCommand cmd = new SqlCommand(enrolQuery, con))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentID);
                cmd.Parameters.AddWithValue("@CourseID", courseID);

                cmd.ExecuteNonQuery();
            }
        }

        private void LoadEnrolmentList()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        e.EnrolmentID,
                        s.StudentName,
                        s.Email,
                        p.ProgrammeName,
                        c.CourseName,
                        c.CourseCode,
                        e.EnrolDate,
                        e.Status
                    FROM Enrolment e
                    INNER JOIN Student s 
                        ON e.StudentID = s.StudentID
                    INNER JOIN Course c 
                        ON e.CourseID = c.CourseID
                    INNER JOIN Programme p 
                        ON c.ProgrammeID = p.ProgrammeID
                    ORDER BY e.EnrolDate DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvEnrolment.DataSource = dt;
                    gvEnrolment.DataBind();
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Login.aspx");
        }
    }
}