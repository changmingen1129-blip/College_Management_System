using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentAnnouncements : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(
        object sender,
        EventArgs e)
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
                    LoadAnnouncements(
                        studentID,
                        "All",
                        ""
                    );
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

        protected void btnFilter_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            int studentID;

            if (!TryGetStudentID(
                out studentID))
            {
                return;
            }

            try
            {
                LoadAnnouncements(
                    studentID,
                    ddlType.SelectedValue,
                    txtSearch.Text.Trim()
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to apply the announcement filter. "
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

            int studentID;

            if (!TryGetStudentID(
                out studentID))
            {
                return;
            }

            ddlType.SelectedValue =
                "All";

            txtSearch.Text =
                "";

            try
            {
                LoadAnnouncements(
                    studentID,
                    "All",
                    ""
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to reset the announcement filter. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void LoadAnnouncements(
            int studentID,
            string type,
            string searchText)
        {
            DataTable table =
                GetAnnouncementData(
                    studentID,
                    type,
                    searchText
                );

            rptAnnouncements.DataSource =
                table;

            rptAnnouncements.DataBind();

            pnlAnnouncements.Visible =
                table.Rows.Count > 0;

            pnlEmpty.Visible =
                table.Rows.Count == 0;

            UpdateSummaryCounts(
                studentID
            );
        }

        private DataTable GetAnnouncementData(
            int studentID,
            string type,
            string searchText)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT DISTINCT
                    a.AnnouncementID,
                    a.Title,
                    a.Message,
                    a.Audience,
                    a.CourseID,
                    a.CreatedByRole,
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

                FROM dbo.Announcement a

                LEFT JOIN dbo.Course c
                    ON a.CourseID = c.CourseID

                LEFT JOIN dbo.Enrolment e
                    ON a.CourseID = e.CourseID
                    AND e.StudentID = @StudentID
                    AND
                    (
                        UPPER(
                            LTRIM(
                                RTRIM(
                                    ISNULL(e.Status, '')
                                )
                            )
                        ) = 'ACTIVE'

                        OR UPPER(
                            LTRIM(
                                RTRIM(
                                    ISNULL(e.Status, '')
                                )
                            )
                        ) = 'ENROLLED'

                        OR UPPER(
                            LTRIM(
                                RTRIM(
                                    ISNULL(e.Status, '')
                                )
                            )
                        ) = 'APPROVED'
                    )

                WHERE a.IsActive = 1

                  AND
                  (
                      a.ExpiryDate IS NULL
                      OR a.ExpiryDate >=
                         CAST(GETDATE() AS DATE)
                  )

                  AND
                  (
                      a.Audience = 'All'
                      OR a.Audience = 'Students'

                      OR
                      (
                          a.Audience = 'Course'
                          AND e.EnrolmentID IS NOT NULL
                      )
                  )

                  AND
                  (
                      @Type = 'All'

                      OR
                      (
                          @Type = 'General'
                          AND a.Audience IN
                              (
                                  'All',
                                  'Students'
                              )
                      )

                      OR
                      (
                          @Type = 'Course'
                          AND a.Audience = 'Course'
                      )
                  )

                  AND
                  (
                      @SearchText = ''

                      OR a.Title LIKE
                         '%' + @SearchText + '%'

                      OR a.Message LIKE
                         '%' + @SearchText + '%'

                      OR c.CourseCode LIKE
                         '%' + @SearchText + '%'

                      OR c.CourseName LIKE
                         '%' + @SearchText + '%'
                  )

                ORDER BY
                    a.CreatedAt DESC,
                    a.AnnouncementID DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    cmd.Parameters.Add(
                        "@Type",
                        SqlDbType.VarChar,
                        20
                    ).Value = type;

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

            return table;
        }

        private void UpdateSummaryCounts(
            int studentID)
        {
            int totalCount = 0;
            int generalCount = 0;
            int courseCount = 0;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    COUNT(
                        DISTINCT a.AnnouncementID
                    ) AS TotalCount,

                    COUNT(
                        DISTINCT
                        CASE
                            WHEN a.Audience IN
                                (
                                    'All',
                                    'Students'
                                )
                            THEN a.AnnouncementID
                        END
                    ) AS GeneralCount,

                    COUNT(
                        DISTINCT
                        CASE
                            WHEN a.Audience = 'Course'
                            THEN a.AnnouncementID
                        END
                    ) AS CourseCount

                FROM dbo.Announcement a

                LEFT JOIN dbo.Enrolment e
                    ON a.CourseID = e.CourseID
                    AND e.StudentID = @StudentID
                    AND
                    (
                        UPPER(
                            LTRIM(
                                RTRIM(
                                    ISNULL(e.Status, '')
                                )
                            )
                        ) = 'ACTIVE'

                        OR UPPER(
                            LTRIM(
                                RTRIM(
                                    ISNULL(e.Status, '')
                                )
                            )
                        ) = 'ENROLLED'

                        OR UPPER(
                            LTRIM(
                                RTRIM(
                                    ISNULL(e.Status, '')
                                )
                            )
                        ) = 'APPROVED'
                    )

                WHERE a.IsActive = 1

                  AND
                  (
                      a.ExpiryDate IS NULL
                      OR a.ExpiryDate >=
                         CAST(GETDATE() AS DATE)
                  )

                  AND
                  (
                      a.Audience = 'All'
                      OR a.Audience = 'Students'

                      OR
                      (
                          a.Audience = 'Course'
                          AND e.EnrolmentID IS NOT NULL
                      )
                  )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            totalCount =
                                reader["TotalCount"] ==
                                DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    reader["TotalCount"]
                                );

                            generalCount =
                                reader["GeneralCount"] ==
                                DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    reader["GeneralCount"]
                                );

                            courseCount =
                                reader["CourseCount"] ==
                                DBNull.Value
                                ? 0
                                : Convert.ToInt32(
                                    reader["CourseCount"]
                                );
                        }
                    }
                }
            }

            lblTotalAnnouncements.Text =
                totalCount.ToString();

            lblGeneralAnnouncements.Text =
                generalCount.ToString();

            lblCourseAnnouncements.Text =
                courseCount.ToString();
        }

        private bool TryGetStudentID(
            out int studentID)
        {
            studentID = 0;

            if (Session["StudentID"] == null)
            {
                Response.Redirect(
                    ResolveUrl("~/StudentLogin.aspx"),
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
                return false;
            }

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
                return false;
            }

            return true;
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
