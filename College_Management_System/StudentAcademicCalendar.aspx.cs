using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentAcademicCalendar : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                Response.Redirect(
                    ResolveUrl("~/StudentLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            int studentID;

            if (!int.TryParse(
                Session["StudentID"].ToString(),
                out studentID))
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect(
                    ResolveUrl("~/StudentLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadEvents(
                        "All",
                        ""
                    );

                    UpdateSummaryCounts();
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load the academic calendar. "
                        + ex.Message,
                        "error"
                    );
                }
            }
        }

        protected void btnFilter_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            try
            {
                LoadEvents(
                    ddlEventType.SelectedValue,
                    txtSearch.Text.Trim()
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to apply the calendar filter. "
                    + ex.Message,
                    "error"
                );
            }
        }

        protected void btnReset_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            ddlEventType.SelectedValue =
                "All";

            txtSearch.Text =
                "";

            try
            {
                LoadEvents(
                    "All",
                    ""
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to reset the calendar filter. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void LoadEvents(
            string eventType,
            string searchText)
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

                WHERE IsActive = 1

                  AND Audience IN
                      (
                          'All',
                          'Students'
                      )

                  AND
                  (
                      @EventType = 'All'
                      OR EventType = @EventType
                  )

                  AND
                  (
                      @SearchText = ''

                      OR EventTitle LIKE
                         '%' + @SearchText + '%'

                      OR EventDescription LIKE
                         '%' + @SearchText + '%'

                      OR Location LIKE
                         '%' + @SearchText + '%'
                  )

                ORDER BY
                    CASE
                        WHEN EndDate >=
                             CAST(GETDATE() AS DATE)
                        THEN 0
                        ELSE 1
                    END,

                    StartDate ASC,
                    EventID DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@EventType",
                        SqlDbType.VarChar,
                        50
                    ).Value = eventType;

                    cmd.Parameters.Add(
                        "@SearchText",
                        SqlDbType.VarChar,
                        150
                    ).Value = searchText;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            rptEvents.DataSource =
                table;

            rptEvents.DataBind();

            pnlEvents.Visible =
                table.Rows.Count > 0;

            pnlEmpty.Visible =
                table.Rows.Count == 0;

            UpdateSummaryCounts();
        }

        private void UpdateSummaryCounts()
        {
            int totalEvents = 0;
            int upcomingEvents = 0;
            int examEvents = 0;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    COUNT(*) AS TotalEvents,

                    SUM(
                        CASE
                            WHEN EndDate >=
                                 CAST(GETDATE() AS DATE)
                            THEN 1
                            ELSE 0
                        END
                    ) AS UpcomingEvents,

                    SUM(
                        CASE
                            WHEN EventType = 'Examination'
                            THEN 1
                            ELSE 0
                        END
                    ) AS ExamEvents

                FROM dbo.AcademicCalendar

                WHERE IsActive = 1

                  AND Audience IN
                      (
                          'All',
                          'Students'
                      )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            totalEvents =
                                reader["TotalEvents"] ==
                                DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    reader["TotalEvents"]
                                );

                            upcomingEvents =
                                reader["UpcomingEvents"] ==
                                DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    reader["UpcomingEvents"]
                                );

                            examEvents =
                                reader["ExamEvents"] ==
                                DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    reader["ExamEvents"]
                                );
                        }
                    }
                }
            }

            lblTotalEvents.Text =
                totalEvents.ToString();

            lblUpcomingEvents.Text =
                upcomingEvents.ToString();

            lblExamEvents.Text =
                examEvents.ToString();
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
