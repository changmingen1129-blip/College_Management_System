using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace College_Management_System
{
    public partial class LecturerAnnouncements : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["LecturerID"] == null)
            {
                Response.Redirect(
                    ResolveUrl("~/LecturerLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            int lecturerID;

            if (!int.TryParse(
                Session["LecturerID"].ToString(),
                out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect(
                    ResolveUrl("~/LecturerLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadAssignedCourses(lecturerID);
                    LoadAnnouncements(lecturerID);
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load announcements. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        private void LoadAssignedCourses(int lecturerID)
        {
            ddlCourse.Items.Clear();

            ddlCourse.Items.Add(
                new ListItem(
                    "-- Select Assigned Course --",
                    "0"
                )
            );

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    c.CourseID,
                    c.CourseCode,
                    c.CourseName
                FROM LecturerCourse lc

                INNER JOIN Course c
                    ON lc.CourseID = c.CourseID

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

        private void LoadAnnouncements(int lecturerID)
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
                    a.CreatedAt,
                    a.ExpiryDate,
                    a.IsActive,
                    c.CourseCode,
                    c.CourseName

                FROM Announcement a

                INNER JOIN Course c
                    ON a.CourseID = c.CourseID

                WHERE a.CreatedByRole = 'Lecturer'
                  AND a.CreatedByID = @LecturerID

                ORDER BY
                    a.CreatedAt DESC,
                    a.AnnouncementID DESC";

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

            gvAnnouncements.DataSource =
                table;

            gvAnnouncements.DataBind();
        }

        protected void btnPublish_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please complete all required fields.",
                    "warning"
                );

                return;
            }

            int lecturerID;

            if (!TryGetLecturerID(out lecturerID))
            {
                return;
            }

            int courseID;

            if (!int.TryParse(
                ddlCourse.SelectedValue,
                out courseID)
                || courseID <= 0)
            {
                ShowMessage(
                    "Please select an assigned course.",
                    "warning"
                );

                return;
            }

            if (!LecturerOwnsCourse(
                lecturerID,
                courseID))
            {
                ShowMessage(
                    "You are not assigned to the selected course.",
                    "error"
                );

                return;
            }

            string title =
                txtTitle.Text.Trim();

            string announcementMessage =
                txtMessage.Text.Trim();

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
                        'Course',
                        @CourseID,
                        'Lecturer',
                        @LecturerID,
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
                            "@CourseID",
                            SqlDbType.Int
                        ).Value = courseID;

                        cmd.Parameters.Add(
                            "@LecturerID",
                            SqlDbType.Int
                        ).Value = lecturerID;

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
                            LoadAnnouncements(lecturerID);

                            ShowMessage(
                                "Course announcement published successfully.",
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

        protected void gvAnnouncements_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            HideMessage();

            int lecturerID;

            if (!TryGetLecturerID(out lecturerID))
            {
                return;
            }

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
                    announcementID,
                    lecturerID
                );
            }
            else if (
                e.CommandName == "DeleteAnnouncement"
            )
            {
                DeleteAnnouncement(
                    announcementID,
                    lecturerID
                );
            }
        }

        private void ToggleAnnouncementStatus(
            int announcementID,
            int lecturerID)
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
                    WHERE AnnouncementID = @AnnouncementID
                      AND CreatedByRole = 'Lecturer'
                      AND CreatedByID = @LecturerID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@AnnouncementID",
                            SqlDbType.Int
                        ).Value = announcementID;

                        cmd.Parameters.Add(
                            "@LecturerID",
                            SqlDbType.Int
                        ).Value = lecturerID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            LoadAnnouncements(lecturerID);

                            ShowMessage(
                                "Announcement status updated successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Announcement could not be found or does not belong to you.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to update announcement status. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void DeleteAnnouncement(
            int announcementID,
            int lecturerID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    DELETE FROM Announcement
                    WHERE AnnouncementID = @AnnouncementID
                      AND CreatedByRole = 'Lecturer'
                      AND CreatedByID = @LecturerID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@AnnouncementID",
                            SqlDbType.Int
                        ).Value = announcementID;

                        cmd.Parameters.Add(
                            "@LecturerID",
                            SqlDbType.Int
                        ).Value = lecturerID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            LoadAnnouncements(lecturerID);

                            ShowMessage(
                                "Announcement deleted successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Announcement could not be found or does not belong to you.",
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

        private bool LecturerOwnsCourse(
            int lecturerID,
            int courseID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT COUNT(*)
                FROM LecturerCourse
                WHERE LecturerID = @LecturerID
                  AND CourseID = @CourseID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@LecturerID",
                        SqlDbType.Int
                    ).Value = lecturerID;

                    cmd.Parameters.Add(
                        "@CourseID",
                        SqlDbType.Int
                    ).Value = courseID;

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
                Response.Redirect(
                    ResolveUrl("~/LecturerLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return false;
            }

            if (!int.TryParse(
                Session["LecturerID"].ToString(),
                out lecturerID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect(
                    ResolveUrl("~/LecturerLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return false;
            }

            return true;
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtMessage.Text = "";
            txtExpiryDate.Text = "";

            ddlStatus.SelectedValue = "1";

            if (ddlCourse.Items.FindByValue("0") != null)
            {
                ddlCourse.SelectedValue = "0";
            }
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
