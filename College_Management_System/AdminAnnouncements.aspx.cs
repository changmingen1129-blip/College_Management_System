using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class AdminAnnouncements : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect(
                    ResolveUrl("~/Login.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadCourses();
                    LoadAnnouncements();
                    UpdateCoursePanel();
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load the announcement page. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        private void LoadCourses()
        {
            ddlCourse.Items.Clear();

            ddlCourse.Items.Add(
                new ListItem(
                    "-- Select Course --",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    CourseID,
                    CourseCode,
                    CourseName
                FROM Course
                ORDER BY
                    CourseCode,
                    CourseName";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string displayText =
                                reader["CourseCode"].ToString()
                                + " - "
                                + reader["CourseName"].ToString();

                            ddlCourse.Items.Add(
                                new ListItem(
                                    displayText,
                                    reader["CourseID"].ToString()
                                )
                            );
                        }
                    }
                }
            }
        }

        private void LoadAnnouncements()
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    a.AnnouncementID,
                    a.Title,
                    a.Message,
                    a.Audience,
                    a.CourseID,
                    a.CreatedByRole,
                    a.CreatedByID,
                    a.CreatedAt,
                    a.ExpiryDate,
                    a.IsActive,

                    CASE
                        WHEN a.CourseID IS NULL
                        THEN ''

                        ELSE
                            ISNULL(c.CourseCode, '')
                            + ' - '
                            + ISNULL(c.CourseName, '')
                    END AS CourseDisplay

                FROM Announcement a

                LEFT JOIN Course c
                    ON a.CourseID =
                       c.CourseID

                ORDER BY
                    a.CreatedAt DESC,
                    a.AnnouncementID DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            gvAnnouncements.DataSource =
                table;

            gvAnnouncements.DataBind();
        }

        protected void ddlAudience_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            HideMessage();
            UpdateCoursePanel();
        }

        private void UpdateCoursePanel()
        {
            pnlCourse.Visible =
                ddlAudience.SelectedValue == "Course";

            if (!pnlCourse.Visible)
            {
                ddlCourse.SelectedValue = "0";
            }
        }

        protected void btnPublish_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please complete all required announcement fields.",
                    "warning"
                );

                return;
            }

            string title =
                txtTitle.Text.Trim();

            string announcementMessage =
                txtMessage.Text.Trim();

            string audience =
                ddlAudience.SelectedValue;

            int courseID = 0;

            if (audience == "Course")
            {
                if (!int.TryParse(
                    ddlCourse.SelectedValue,
                    out courseID)
                    || courseID <= 0)
                {
                    ShowMessage(
                        "Please select a course for the course announcement.",
                        "warning"
                    );

                    return;
                }
            }

            DateTime expiryDate;
            bool hasExpiryDate =
                DateTime.TryParse(
                    txtExpiryDate.Text,
                    out expiryDate
                );

            if (
                hasExpiryDate
                && expiryDate.Date < DateTime.Today
            )
            {
                ShowMessage(
                    "The expiry date cannot be earlier than today.",
                    "warning"
                );

                return;
            }

            bool isActive =
                ddlStatus.SelectedValue == "1";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    INSERT INTO Announcement
                    (
                        Title,
                        Message,
                        Audience,
                        CourseID,
                        CreatedByRole,
                        CreatedByID,
                        CreatedAt,
                        ExpiryDate,
                        IsActive
                    )
                    VALUES
                    (
                        @Title,
                        @Message,
                        @Audience,
                        @CourseID,
                        @CreatedByRole,
                        @CreatedByID,
                        GETDATE(),
                        @ExpiryDate,
                        @IsActive
                    )";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@Title",
                            SqlDbType.VarChar,
                            150
                        ).Value = title;

                        cmd.Parameters.Add(
                            "@Message",
                            SqlDbType.VarChar,
                            1000
                        ).Value = announcementMessage;

                        cmd.Parameters.Add(
                            "@Audience",
                            SqlDbType.VarChar,
                            30
                        ).Value = audience;

                        if (
                            audience == "Course"
                            && courseID > 0
                        )
                        {
                            cmd.Parameters.Add(
                                "@CourseID",
                                SqlDbType.Int
                            ).Value = courseID;
                        }
                        else
                        {
                            cmd.Parameters.Add(
                                "@CourseID",
                                SqlDbType.Int
                            ).Value = DBNull.Value;
                        }

                        cmd.Parameters.Add(
                            "@CreatedByRole",
                            SqlDbType.VarChar,
                            20
                        ).Value = "Admin";

                        cmd.Parameters.Add(
                            "@CreatedByID",
                            SqlDbType.Int
                        ).Value = DBNull.Value;

                        if (hasExpiryDate)
                        {
                            cmd.Parameters.Add(
                                "@ExpiryDate",
                                SqlDbType.Date
                            ).Value = expiryDate.Date;
                        }
                        else
                        {
                            cmd.Parameters.Add(
                                "@ExpiryDate",
                                SqlDbType.Date
                            ).Value = DBNull.Value;
                        }

                        cmd.Parameters.Add(
                            "@IsActive",
                            SqlDbType.Bit
                        ).Value = isActive;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            ClearForm();
                            LoadAnnouncements();

                            ShowMessage(
                                "Announcement published successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Unable to publish the announcement.",
                                "error"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to publish the announcement. "
                    + ex.Message,
                    "error"
                );
            }
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();
            ClearForm();
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtMessage.Text = "";
            txtExpiryDate.Text = "";

            ddlAudience.SelectedValue = "All";
            ddlStatus.SelectedValue = "1";

            if (ddlCourse.Items.FindByValue("0") != null)
            {
                ddlCourse.SelectedValue = "0";
            }

            UpdateCoursePanel();
        }

        protected void gvAnnouncements_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            HideMessage();

            int announcementID;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out announcementID))
            {
                ShowMessage(
                    "Invalid announcement selected.",
                    "error"
                );

                return;
            }

            if (e.CommandName == "ToggleStatus")
            {
                ToggleAnnouncementStatus(
                    announcementID
                );
            }
            else if (
                e.CommandName == "DeleteAnnouncement"
            )
            {
                DeleteAnnouncement(
                    announcementID
                );
            }
        }

        private void ToggleAnnouncementStatus(
            int announcementID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    UPDATE Announcement
                    SET IsActive =
                        CASE
                            WHEN IsActive = 1
                            THEN 0
                            ELSE 1
                        END
                    WHERE AnnouncementID =
                          @AnnouncementID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@AnnouncementID",
                            SqlDbType.Int
                        ).Value = announcementID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            LoadAnnouncements();

                            ShowMessage(
                                "Announcement status updated successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Announcement could not be found.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to update the announcement status. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void DeleteAnnouncement(
            int announcementID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    DELETE FROM Announcement
                    WHERE AnnouncementID =
                          @AnnouncementID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@AnnouncementID",
                            SqlDbType.Int
                        ).Value = announcementID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            LoadAnnouncements();

                            ShowMessage(
                                "Announcement deleted successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Announcement could not be found.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to delete the announcement. "
                    + ex.Message,
                    "error"
                );
            }
        }

        public string GetAudienceClass(
            string audience)
        {
            if (audience == "Students")
            {
                return
                    "audience-badge audience-students";
            }

            if (audience == "Lecturers")
            {
                return
                    "audience-badge audience-lecturers";
            }

            if (audience == "Course")
            {
                return
                    "audience-badge audience-course";
            }

            return
                "audience-badge audience-all";
        }

        public string GetAudienceText(
            string audience)
        {
            if (audience == "Students")
            {
                return "Students";
            }

            if (audience == "Lecturers")
            {
                return "Lecturers";
            }

            if (audience == "Course")
            {
                return "Course";
            }

            return "All Users";
        }

        private void ShowMessage(
            string message,
            string type)
        {
            lblMessage.Visible = true;
            lblMessage.Text = message;

            if (type == "success")
            {
                lblMessage.CssClass =
                    "message-label alert alert-success";
            }
            else if (type == "warning")
            {
                lblMessage.CssClass =
                    "message-label alert alert-warning";
            }
            else
            {
                lblMessage.CssClass =
                    "message-label alert alert-danger";
            }
        }

        private void HideMessage()
        {
            lblMessage.Visible = false;
            lblMessage.Text = "";
        }
    }


}
