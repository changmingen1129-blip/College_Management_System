using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class AdminAcademicCalendar : System.Web.UI.Page
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
                    LoadEvents();
                    ClearForm();
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load academic calendar events. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        protected void btnSave_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please complete all required event fields.",
                    "warning"
                );

                return;
            }

            string eventTitle =
                txtEventTitle.Text.Trim();

            string eventDescription =
                txtEventDescription.Text.Trim();

            string eventType =
                ddlEventType.SelectedValue;

            string audience =
                ddlAudience.SelectedValue;

            string location =
                txtLocation.Text.Trim();

            DateTime startDate;
            DateTime endDate;

            if (!DateTime.TryParse(
                txtStartDate.Text,
                out startDate))
            {
                ShowMessage(
                    "Please enter a valid start date.",
                    "warning"
                );

                return;
            }

            if (!DateTime.TryParse(
                txtEndDate.Text,
                out endDate))
            {
                ShowMessage(
                    "Please enter a valid end date.",
                    "warning"
                );

                return;
            }

            if (endDate.Date < startDate.Date)
            {
                ShowMessage(
                    "The end date cannot be earlier than the start date.",
                    "warning"
                );

                return;
            }

            bool isActive =
                ddlStatus.SelectedValue == "1";

            int eventID;

            if (!int.TryParse(
                hfEventID.Value,
                out eventID))
            {
                eventID = 0;
            }

            try
            {
                if (eventID > 0)
                {
                    UpdateEvent(
                        eventID,
                        eventTitle,
                        eventDescription,
                        eventType,
                        startDate,
                        endDate,
                        audience,
                        location,
                        isActive
                    );
                }
                else
                {
                    InsertEvent(
                        eventTitle,
                        eventDescription,
                        eventType,
                        startDate,
                        endDate,
                        audience,
                        location,
                        isActive
                    );
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to save the academic event. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void InsertEvent(
            string eventTitle,
            string eventDescription,
            string eventType,
            DateTime startDate,
            DateTime endDate,
            string audience,
            string location,
            bool isActive)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                INSERT INTO dbo.AcademicCalendar
                (
                    EventTitle,
                    EventDescription,
                    EventType,
                    StartDate,
                    EndDate,
                    Audience,
                    Location,
                    CreatedAt,
                    IsActive
                )
                VALUES
                (
                    @EventTitle,
                    @EventDescription,
                    @EventType,
                    @StartDate,
                    @EndDate,
                    @Audience,
                    @Location,
                    GETDATE(),
                    @IsActive
                )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    AddEventParameters(
                        cmd,
                        eventTitle,
                        eventDescription,
                        eventType,
                        startDate,
                        endDate,
                        audience,
                        location,
                        isActive
                    );

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        ClearForm();
                        LoadEvents();

                        ShowMessage(
                            "Academic event created successfully.",
                            "success"
                        );
                    }
                    else
                    {
                        ShowMessage(
                            "Unable to create the academic event.",
                            "error"
                        );
                    }
                }
            }
        }

        private void UpdateEvent(
            int eventID,
            string eventTitle,
            string eventDescription,
            string eventType,
            DateTime startDate,
            DateTime endDate,
            string audience,
            string location,
            bool isActive)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                UPDATE dbo.AcademicCalendar
                SET
                    EventTitle = @EventTitle,
                    EventDescription = @EventDescription,
                    EventType = @EventType,
                    StartDate = @StartDate,
                    EndDate = @EndDate,
                    Audience = @Audience,
                    Location = @Location,
                    IsActive = @IsActive
                WHERE EventID = @EventID";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    AddEventParameters(
                        cmd,
                        eventTitle,
                        eventDescription,
                        eventType,
                        startDate,
                        endDate,
                        audience,
                        location,
                        isActive
                    );

                    cmd.Parameters.Add(
                        "@EventID",
                        SqlDbType.Int
                    ).Value = eventID;

                    con.Open();

                    int affectedRows =
                        cmd.ExecuteNonQuery();

                    if (affectedRows > 0)
                    {
                        ClearForm();
                        LoadEvents();

                        ShowMessage(
                            "Academic event updated successfully.",
                            "success"
                        );
                    }
                    else
                    {
                        ShowMessage(
                            "Academic event could not be found.",
                            "warning"
                        );
                    }
                }
            }
        }

        private void AddEventParameters(
            SqlCommand cmd,
            string eventTitle,
            string eventDescription,
            string eventType,
            DateTime startDate,
            DateTime endDate,
            string audience,
            string location,
            bool isActive)
        {
            cmd.Parameters.Add(
                "@EventTitle",
                SqlDbType.VarChar,
                150
            ).Value = eventTitle;

            cmd.Parameters.Add(
                "@EventDescription",
                SqlDbType.VarChar,
                1000
            ).Value =
                string.IsNullOrWhiteSpace(
                    eventDescription
                )
                ? (object)DBNull.Value
                : eventDescription;

            cmd.Parameters.Add(
                "@EventType",
                SqlDbType.VarChar,
                50
            ).Value = eventType;

            cmd.Parameters.Add(
                "@StartDate",
                SqlDbType.Date
            ).Value = startDate.Date;

            cmd.Parameters.Add(
                "@EndDate",
                SqlDbType.Date
            ).Value = endDate.Date;

            cmd.Parameters.Add(
                "@Audience",
                SqlDbType.VarChar,
                30
            ).Value = audience;

            cmd.Parameters.Add(
                "@Location",
                SqlDbType.VarChar,
                150
            ).Value =
                string.IsNullOrWhiteSpace(
                    location
                )
                ? (object)DBNull.Value
                : location;

            cmd.Parameters.Add(
                "@IsActive",
                SqlDbType.Bit
            ).Value = isActive;
        }

        private void LoadEvents()
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    EventID,
                    EventTitle,
                    EventDescription,
                    EventType,
                    StartDate,
                    EndDate,
                    Audience,
                    Location,
                    CreatedAt,
                    IsActive
                FROM dbo.AcademicCalendar
                ORDER BY
                    StartDate DESC,
                    EventID DESC";

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

            gvEvents.DataSource =
                table;

            gvEvents.DataBind();
        }

        protected void gvEvents_RowCommand(
            object sender,
            System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            HideMessage();

            int eventID;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out eventID))
            {
                ShowMessage(
                    "Invalid academic event selected.",
                    "error"
                );

                return;
            }

            if (e.CommandName == "EditEvent")
            {
                LoadEventForEditing(eventID);
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleEventStatus(eventID);
            }
            else if (e.CommandName == "DeleteEvent")
            {
                DeleteEvent(eventID);
            }
        }

        private void LoadEventForEditing(
            int eventID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    SELECT
                        EventID,
                        EventTitle,
                        EventDescription,
                        EventType,
                        StartDate,
                        EndDate,
                        Audience,
                        Location,
                        IsActive
                    FROM dbo.AcademicCalendar
                    WHERE EventID = @EventID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@EventID",
                            SqlDbType.Int
                        ).Value = eventID;

                        con.Open();

                        using (SqlDataReader reader =
                            cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hfEventID.Value =
                                    reader["EventID"].ToString();

                                txtEventTitle.Text =
                                    reader["EventTitle"].ToString();

                                txtEventDescription.Text =
                                    reader["EventDescription"] ==
                                    DBNull.Value
                                    ? ""
                                    : reader["EventDescription"].ToString();

                                string eventType =
                                    reader["EventType"].ToString();

                                if (
                                    ddlEventType.Items.FindByValue(
                                        eventType
                                    ) != null
                                )
                                {
                                    ddlEventType.SelectedValue =
                                        eventType;
                                }

                                txtStartDate.Text =
                                    Convert.ToDateTime(
                                        reader["StartDate"]
                                    ).ToString("yyyy-MM-dd");

                                txtEndDate.Text =
                                    Convert.ToDateTime(
                                        reader["EndDate"]
                                    ).ToString("yyyy-MM-dd");

                                string audience =
                                    reader["Audience"].ToString();

                                if (
                                    ddlAudience.Items.FindByValue(
                                        audience
                                    ) != null
                                )
                                {
                                    ddlAudience.SelectedValue =
                                        audience;
                                }

                                txtLocation.Text =
                                    reader["Location"] ==
                                    DBNull.Value
                                    ? ""
                                    : reader["Location"].ToString();

                                ddlStatus.SelectedValue =
                                    Convert.ToBoolean(
                                        reader["IsActive"]
                                    )
                                    ? "1"
                                    : "0";

                                btnSave.Text =
                                    "Update Event";

                                ShowMessage(
                                    "Academic event loaded. Update the details and click Update Event.",
                                    "success"
                                );
                            }
                            else
                            {
                                ShowMessage(
                                    "Academic event could not be found.",
                                    "warning"
                                );
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load the academic event. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void ToggleEventStatus(
            int eventID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    UPDATE dbo.AcademicCalendar
                    SET IsActive =
                        CASE
                            WHEN IsActive = 1
                            THEN 0
                            ELSE 1
                        END
                    WHERE EventID = @EventID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@EventID",
                            SqlDbType.Int
                        ).Value = eventID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            LoadEvents();

                            ShowMessage(
                                "Academic event status updated successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Academic event could not be found.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to update the academic event status. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void DeleteEvent(
            int eventID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    string query = @"
                    DELETE FROM dbo.AcademicCalendar
                    WHERE EventID = @EventID";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add(
                            "@EventID",
                            SqlDbType.Int
                        ).Value = eventID;

                        con.Open();

                        int affectedRows =
                            cmd.ExecuteNonQuery();

                        if (affectedRows > 0)
                        {
                            if (
                                hfEventID.Value ==
                                eventID.ToString()
                            )
                            {
                                ClearForm();
                            }

                            LoadEvents();

                            ShowMessage(
                                "Academic event deleted successfully.",
                                "success"
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Academic event could not be found.",
                                "warning"
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to delete the academic event. "
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
            hfEventID.Value = "0";

            txtEventTitle.Text = "";
            txtEventDescription.Text = "";
            txtStartDate.Text = "";
            txtEndDate.Text = "";
            txtLocation.Text = "";

            ddlEventType.SelectedValue =
                "Semester";

            ddlAudience.SelectedValue =
                "All";

            ddlStatus.SelectedValue =
                "1";

            btnSave.Text =
                "Save Event";
        }

        public string GetEventTypeClass(
            string eventType)
        {
            if (eventType == "Registration")
            {
                return
                    "type-badge type-registration";
            }

            if (eventType == "Examination")
            {
                return
                    "type-badge type-examination";
            }

            if (eventType == "Holiday")
            {
                return
                    "type-badge type-holiday";
            }

            if (eventType == "Activity")
            {
                return
                    "type-badge type-activity";
            }

            if (eventType == "Deadline")
            {
                return
                    "type-badge type-deadline";
            }

            return
                "type-badge type-semester";
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
