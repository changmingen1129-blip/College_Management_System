using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace College_Management_System
{
    public partial class StudentFees : System.Web.UI.Page
    {
        private readonly string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;


    protected void Page_Load(
        object sender,
        EventArgs e)
        {
            int studentID;

            if (!TryGetStudentID(
                out studentID))
            {
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadFees(
                        studentID,
                        "All",
                        ""
                    );
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load your fee records. "
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
                LoadFees(
                    studentID,
                    ddlStatus.SelectedValue,
                    txtSearch.Text.Trim()
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to apply the fee filter. "
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

            ddlStatus.SelectedValue =
                "All";

            txtSearch.Text =
                "";

            try
            {
                LoadFees(
                    studentID,
                    "All",
                    ""
                );
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to reset the fee filter. "
                    + ex.Message,
                    "error"
                );
            }
        }

        private void LoadFees(
            int studentID,
            string paymentStatus,
            string searchText)
        {
            DataTable table =
                new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    f.FeeID,
                    f.StudentID,
                    f.CourseID,
                    f.FeeType,
                    f.Description,
                    f.TotalAmount,
                    f.PaidAmount,
                    f.DueDate,
                    f.CreatedAt,
                    c.CourseCode,
                    c.CourseName,

                    CASE
                        WHEN f.TotalAmount - f.PaidAmount < 0
                        THEN 0
                        ELSE f.TotalAmount - f.PaidAmount
                    END AS OutstandingAmount,

                    CASE
                        WHEN f.PaidAmount >= f.TotalAmount
                        THEN 'Paid'

                        WHEN f.DueDate <
                             CAST(GETDATE() AS DATE)
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Overdue'

                        WHEN f.PaidAmount > 0
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Partially Paid'

                        ELSE 'Unpaid'
                    END AS DisplayStatus

                FROM dbo.StudentFee f

                LEFT JOIN dbo.Course c
                    ON f.CourseID = c.CourseID

                WHERE f.StudentID =
                      @StudentID

                AND
                (
                    @PaymentStatus = 'All'

                    OR
                    CASE
                        WHEN f.PaidAmount >= f.TotalAmount
                        THEN 'Paid'

                        WHEN f.DueDate <
                             CAST(GETDATE() AS DATE)
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Overdue'

                        WHEN f.PaidAmount > 0
                             AND f.PaidAmount < f.TotalAmount
                        THEN 'Partially Paid'

                        ELSE 'Unpaid'
                    END = @PaymentStatus
                )

                AND
                (
                    @SearchText = ''

                    OR f.FeeType LIKE
                       '%' + @SearchText + '%'

                    OR f.Description LIKE
                       '%' + @SearchText + '%'

                    OR c.CourseCode LIKE
                       '%' + @SearchText + '%'

                    OR c.CourseName LIKE
                       '%' + @SearchText + '%'
                )

                ORDER BY
                    CASE
                        WHEN f.PaidAmount >= f.TotalAmount
                        THEN 3

                        WHEN f.DueDate <
                             CAST(GETDATE() AS DATE)
                             AND f.PaidAmount < f.TotalAmount
                        THEN 0

                        WHEN f.PaidAmount > 0
                             AND f.PaidAmount < f.TotalAmount
                        THEN 1

                        ELSE 2
                    END,

                    f.DueDate ASC,
                    f.FeeID DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@StudentID",
                        SqlDbType.Int
                    ).Value = studentID;

                    cmd.Parameters.Add(
                        "@PaymentStatus",
                        SqlDbType.VarChar,
                        30
                    ).Value =
                        string.IsNullOrWhiteSpace(
                            paymentStatus
                        )
                            ? "All"
                            : paymentStatus;

                    cmd.Parameters.Add(
                        "@SearchText",
                        SqlDbType.VarChar,
                        150
                    ).Value =
                        searchText ?? "";

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }
            }

            rptFees.DataSource =
                table;

            rptFees.DataBind();

            pnlFees.Visible =
                table.Rows.Count > 0;

            pnlEmpty.Visible =
                table.Rows.Count == 0;

            UpdateSummary(
                studentID
            );
        }

        private void UpdateSummary(
            int studentID)
        {
            decimal totalFees = 0;
            decimal totalPaid = 0;
            decimal outstanding = 0;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                SELECT
                    ISNULL(
                        SUM(TotalAmount),
                        0
                    ) AS TotalFees,

                    ISNULL(
                        SUM(PaidAmount),
                        0
                    ) AS TotalPaid,

                    ISNULL(
                        SUM(
                            CASE
                                WHEN TotalAmount - PaidAmount < 0
                                THEN 0
                                ELSE TotalAmount - PaidAmount
                            END
                        ),
                        0
                    ) AS OutstandingAmount

                FROM dbo.StudentFee

                WHERE StudentID =
                      @StudentID";

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
                            totalFees =
                                reader["TotalFees"] ==
                                DBNull.Value
                                    ? 0
                                    : Convert.ToDecimal(
                                        reader["TotalFees"]
                                    );

                            totalPaid =
                                reader["TotalPaid"] ==
                                DBNull.Value
                                    ? 0
                                    : Convert.ToDecimal(
                                        reader["TotalPaid"]
                                    );

                            outstanding =
                                reader["OutstandingAmount"] ==
                                DBNull.Value
                                    ? 0
                                    : Convert.ToDecimal(
                                        reader[
                                            "OutstandingAmount"
                                        ]
                                    );
                        }
                    }
                }
            }

            lblTotalFees.Text =
                totalFees.ToString("N2");

            lblTotalPaid.Text =
                totalPaid.ToString("N2");

            lblOutstanding.Text =
                outstanding.ToString("N2");
        }

        private bool TryGetStudentID(
            out int studentID)
        {
            studentID = 0;

            if (Session["StudentID"] == null)
            {
                RedirectToStudentLogin();
                return false;
            }

            if (!int.TryParse(
                Session["StudentID"].ToString(),
                out studentID)
                || studentID <= 0)
            {
                Session.Clear();
                Session.Abandon();

                RedirectToStudentLogin();
                return false;
            }

            return true;
        }

        private void RedirectToStudentLogin()
        {
            Response.Redirect(
                ResolveUrl("~/StudentLogin.aspx"),
                false
            );

            Context.ApplicationInstance
                .CompleteRequest();
        }

        private void ShowMessage(
            string message,
            string type)
        {
            lblMessage.Visible =
                true;

            lblMessage.Text =
                message;

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
            lblMessage.Visible =
                false;

            lblMessage.Text =
                "";
        }
    }


}
